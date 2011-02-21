require "nephophobia/compute"

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

    def compute
      @compute ||= Nephophobia::Compute.new self #Base.new(@connection, @path, @aws)
    end

    def raw method, params
      @connection.send method, @path, :query => @aws.signed_params(method, params)
    end

    def action method, inflict, filter
      raw method, { "Action" => inflict }.merge(filter)
    end
  end
end
