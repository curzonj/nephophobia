##
# Taken from geemus/fog
#
# TODO: document

require "cgi"
require "openssl"
require "base64"

class AWS
  def initialize options
    @host       = options[:host]
    @port       = options[:port]
    @path       = options[:path]
    @access_key = options[:access_key]
    @secret_key = options[:secret_key]
    @project    = options[:project]
  end

  def signed_params method, params
    sign method, common_params.merge(params)
  end

private
  def common_params
    {
      "AWSAccessKeyId"    => "#{@access_key}:#{@project}",
      "SignatureMethod"   => "HmacSHA256",
      "SignatureVersion"  => "2",
      "Timestamp"         => "2011-02-19T07:17:56Z", #Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
      "Version"           => "2010-08-31"
    }
  end

  def sign method, params
    sorted_params = sort_params params

    data   = "#{method.upcase}\n#{@host}:#{@port}\n#{@path}\n" << sorted_params.chop
    digest = OpenSSL::Digest::Digest.new "sha256"
    signed = OpenSSL::HMAC.digest digest, @secret_key, data
    sorted_params << "Signature=#{CGI.escape(Base64.encode64(signed).chomp!).gsub /\+/, '%20'}"

    sorted_params
  end

  def sort_params params
    params.keys.sort.inject("") { |result, key|
      result << "#{key}=#{CGI.escape(params[key]).gsub(/\+/, '%20')}&" if params[key]
    }
  end
end
