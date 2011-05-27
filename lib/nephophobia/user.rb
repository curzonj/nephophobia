##
# __Must__ execute as a user with the +admin+ role.

module Nephophobia
  class UserData
    attr_reader :accesskey, :username, :secretkey

    attr_accessor :attributes

    def initialize attributes
      @attributes = attributes

      @accesskey = attributes['accesskey']
      @username  = attributes['username']
      @secretkey = attributes['secretkey']
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
    # +user_name+: A String containing a nova user_name.
    # +project_name+: A String containing a nova project_name name.

    def credentials user_name, project_name
      params = {
        "Name"    => user_name,
        "Project" => project_name
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

    ##
    # Apply a set of global and per-project permissions to the given 'user_name'.
    # Do the following if the 'user_name' is not a member of the 'project_name'.
    #  - Add the 'user_name' with the default role (sysadmin) globally.
    #  - Add the 'user_name' to the 'project_name', with the default role (sysadmin).
    #  - Add the 'user_name' as a member to the 'project_name'
    #
    # +user_name+: A String representing a nova user_name.
    # +project_name+: A String representing a nova project_name name.

    def register user_name, project_name
      unless @client.project.member? user_name, project_name
        @client.role.create user_name
        @client.role.create user_name, project_name
        @client.project.add_member user_name, project_name
      end
    end
  end
end
