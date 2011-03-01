require "aws"
require "hashify"
require "nephophobia/compute"
require "nephophobia/image"
require "nephophobia/project"
require "nephophobia/user"

require "hugs"

module Nephophobia
  class Client
    ##
    # Required:
    # +host+: A String with the host to connect.
    # +access_key+: A String containing the AWS Access Key.
    # +secret_key+: A String containing the AWS Secret Key.
    # +project+: A String containing the "Project Name" the
    #            Acccess Key is intended for.

    def initialize options
      @port = options[:port] || 8773
      @path = options[:path] || "/services/Cloud"

      @connection = Hugs::Client.new(
        :host     => options[:host],
        :scheme   => options[:scheme] || "http",
        :port     => @port,
        :type     => options[:type] || :xml
      )
      @connection.raise_4xx = true
      @connection.raise_5xx = true

      @aws = AWS.new(
        :host       => options[:host],
        :port       => @port,
        :path       => @path,
        :access_key => options[:access_key],
        :secret_key => options[:secret_key],
        :project    => options[:project]
      )
    end

    ##
    # Worker method which constructs the properly signed URL, and
    # performs the Net::HTTP call.
    # Returns a typical Net::HTTP response with a Hash body.
    #
    # +method+: The HTTP method used for the request.
    # +params+: A Hash containing the

    def raw method, params
      response      = @connection.send method, @path, :query => @aws.signed_params(method, params)
      response.body = Hashify.convert response.body.root

      response
    end

    ##
    # Vanity wrapper around #raw.
    #
    # +inflict+: A String with the EC2 API action to execute.
    # +filter+: An optional Hash containing the EC2 API filters.

    def action inflict, filter
      raw "get", { "Action" => inflict }.merge(filter)
    end

    ##
    # Provide a simple interface to the EC2 Compute resources.

    def compute
      @compute ||= Nephophobia::Compute.new self
    end

    ##
    # Provide a simple interface to the EC2 Image resources.

    def image
      @image ||= Nephophobia::Image.new self
    end
  end
end
