module Nephophobia
  class Client
    ##
    # Required:
    # +host+: A String with the host to connect.
    # +access_key+: A String containing the AWS Access Key.
    # +secret_key+: A String containing the AWS Secret Key.
    # +project+: An optional String containing the "Project Name"
    #            the Acccess Key is intended for.

    def initialize options
      @port = options[:port] || 8773

      @connection = Hugs::Client.new(
        :host         => options[:host],
        :scheme       => options[:scheme] || "http",
        :port         => @port,
        :type         => options[:type] || :xml,
        :raise_errors => true
      )

      @aws = AWS.new(
        :host       => options[:host],
        :port       => @port,
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
      @aws.path     = @path
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
      @path      = "/services/Cloud"
      @compute ||= Nephophobia::Compute.new self
    end

    ##
    # Provide a simple interface to the EC2 Credential resources.

    def credential
      @path         = "/services/Cloud"
      @credential ||= Nephophobia::Credential.new self
    end

    ##
    # Provide a simple interface to the EC2 Image resources.

    def image
      @path    = "/services/Cloud"
      @image ||= Nephophobia::Image.new self
    end

    ##
    # Provide a simple interface to the OpenStack Project resources.

    def project
      @path      = "/services/Admin"
      @project ||= Nephophobia::Project.new self
    end

    ##
    # Provide a simple interface to the OpenStack User resources.

    def user
      @path   = "/services/Admin"
      @user ||= Nephophobia::User.new self
    end

    ##
    # Provide a simple interface to the OpenStack Role resources.

    def role
      @path   = "/services/Admin"
      @role ||= Nephophobia::Role.new self
    end
  end
end
