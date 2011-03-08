module Nephophobia
  class UserData
    attr_reader :accesskey, :username, :secretkey

    def initialize hash
      @accesskey = hash['accesskey']
      @username  = hash['username']
      @secretkey = hash['secretkey']
    end
  end

  class User
    def initialize client
      @client = client
    end

    ##
    # Creates the given 'user_name'.
    # Returns a response to the state change.
    #
    # +user_name+: A String representing a nova user_name.

    def create user_name
      response = @client.action "RegisterUser", "Name" => user_name

      UserData.new response.body['RegisterUserResponse']
    end

    ##
    # Returns the credentials for a given 'user_name' for the specified 'project_name'.
    #
    # +user_name+: A String representing a nova user_name.
    # +project_name+: A String representing a nova project_name name.

    def credentials user_name, project_name
      params = {
        "name"    => user_name,
        "project" => project_name
      }

      response = @client.action "GenerateX509ForUser", params

      Base64.decode64 response.body['GenerateX509ForUserResponse']['file']
    end

    ##
    # Removes the given 'user_name'.
    # Returns a response to the state change.
    #
    # +user_name+: A String representing a nova user_name.

    def destroy user_name
      response = @client.action "DeregisterUser", "Name" => user_name

      ResponseData.new response.body['DeregisterUserResponse']
    end

    ##
    # Returns information about the given 'user_name'.
    #
    # +user_name+: A String representing the user_name.

    def find user_name
      response = @client.action "DescribeUser", "Name" => user_name

      UserData.new response.body['DescribeUserResponse']
    rescue Hugs::Errors::BadRequest
    end
  end
end
