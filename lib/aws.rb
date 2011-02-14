##
# Extracted from from grempe/amazon-ec2
#
# TODO: Could use better tests.

require "cgi"
require "openssl"
require "base64"

class AWS
  ##
  # Builds the canonical string for signing requests. This strips out all '&', '?', and '='
  # from the query string to be signed.  The parameters in the path passed in must already
  # be sorted in case-insensitive alphabetical order and must not be url encoded.
  #
  # +params+: A Hash that will be sorted and encoded.
  # +host+: A String with the hostname of the API endpoint.
  # +host+: An Integer with the HTTP port of the API endpoint.
  # +method+: A String with the HTTP method that will be used to submit the request.
  # +base+: A String to the base URI path for submission.

  def self.canonical_string params, host, port, method="POST", base="/"
    ### Sort, and encode parameters into a canonical string.
    sorted_params  = params.sort { |x,y| x[0] <=> y[0] }
    encoded_params = sorted_params.collect do |p|
      encoded = "#{CGI::escape p[0].to_s}=#{CGI::escape p[1].to_s}"
      # Ensure spaces are encoded as '%20', not '+'
      encoded = encoded.gsub '+', '%20'
      # According to RFC3986 (the scheme for values expected by signing requests), '~'
      # should not be encoded
      encoded = encoded.gsub '%7E', '~'
    end

    ### Generate the request description string.
    "#{method}\n#{host}:#{port}\n#{base}\n#{encoded_params.join "&"}"
  end

  ##
  # Encodes the given string with the secret_access_key by taking the
  # hmac-sha1 sum, and then base64 encoding it.  Optionally, it will also
  # url encode the result of that to protect the string if it's going to
  # be used as a query string parameter.
  #
  # +secret_access_key+: A String containing the user's key for signing.
  # +str+: A String to be hashed and encoded.
  # +urlencode+: A Boolean whether or not to URL encode the result.

  def AWS.encode secret_access_key, str, urlencode=true
    digest   = OpenSSL::Digest::Digest.new "sha256"
    b64_hmac = Base64.encode64(
      OpenSSL::HMAC.digest digest, secret_access_key, str
    ).gsub "\n",""

    urlencode ? CGI::escape(b64_hmac) : b64_hmac
  end
end
