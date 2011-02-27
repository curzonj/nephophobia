module Nephophobia
  class User
    DEFAULT_ROLE = "sysadmin"

    def initialize client
      @client = client
    end

    ##
    # Adds the given 'user_name' to the specified "project_name's" '::DEFAULT_ROLE'.
    # Returns a response to the state change.
    #
    # +user_name+: A String representing a nova user_name.
    # +project_name+: A String representing a nova project_name name.

    def add_role user_name, project_name
      modify_role user_name, "add", project_name
    end

    ##
    # Creates the given 'user_name'.
    # Returns a response to the state change.
    #
    # +user_name+: A String representing a nova user_name.

    def create user_name
      response = @client.action "RegisterUser", "Name" => user_name

      response.body
    end

    ##
    # Removes the given 'user_name'.
    # Returns a response to the state change.
    #
    # +user_name+: A String representing a nova user_name.

    def destroy user_name
      response = @client.action "DeregisterUser", "Name" => user_name

      response.body
    end

    ##
    # Returns information about the given 'user_name'.
    #
    # +user_name+: A String representing the user_name.

    def find user_name
      response = @client.action "DescribeUser", "Name" => user_name

      response.body
    end

    ##
    # Removes the given 'user_name' from the specified "project_name's" '::DEFAULT_ROLE'.
    #
    # +user_name+: A String representing a nova user_name.
    # +project_name+: A String representing a nova project_name name.

    def remove_role user_name, project_name
      modify_role user_name, "remove", project_name
    end

  private
    def modify_role user_name, operation, project_name
      params = {
        "User"      => user_name,
        "Role"      => DEFAULT_ROLE,
        "Operation" => operation
      }

      response = @client.action "ModifyUserRole", params

      response.body
    end
  end
end
