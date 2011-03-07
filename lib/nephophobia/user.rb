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
