module Nephophobia
  class User
    DEFAULT_ROLE = "sysadmin"

    def initialize client
      @client = client
    end

    ##
    # Adds the given 'username' to the specified "project's" '::DEFAULT_ROLE'.
    # Returns a response to the state change.
    #
    # +username+: A String representing a nova username.
    # +project+: A String representing a nova project name.

    def add_role username, project
      modify_role username, "add", project
    end

    ##
    # Creates the given 'username'.
    # Returns a response to the state change.
    #
    # +username+: A String representing a nova username.

    def create username
      response = @client.action "get", "RegisterUser", "Name" => username

      response.body
    end

    ##
    # Removes the given 'username', and un-registers from the specified project.
    # Returns a response to the state change.
    #
    # +username+: A String representing a nova username.

    def destroy username, project
      remove_role username, project

      response = @client.action "get", "DeregisterUser", "Name" => username

      response.body
    end

    ##
    # Returns information about the given 'username'.
    #
    # +username+: A String representing the username.

    def find username
      response = @client.action "get", "DescribeUser", "Name" => username

      response.body
    end

    ##
    # Removes the given 'username' from the specified "project's" '::DEFAULT_ROLE'.
    #
    # +username+: A String representing a nova username.
    # +project+: A String representing a nova project name.

    def remove_role username, project
      modify_role username, "remove", project
    end

  private
    def modify_role username, operation, project
      params = {
        "User"      => username,
        "Role"      => DEFAULT_ROLE,
        "Operation" => operation
      }

      response = @client.action "get", "ModifyUserRole", params

      response.body
    end
  end
end
