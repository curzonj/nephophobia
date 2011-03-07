module Nephophobia
  class RoleData
    attr_reader :name

    def initialize hash
      @name = hash['role']
    end
  end

  class Role
    DEFAULT = "sysadmin"

    def initialize client
      @client = client
    end

    ##
    # Adds the given 'user_name' to the specified "project_name's" 'Role::DEFAULT'.
    # Returns a response to the state change.
    #
    # +user_name+: A String representing a nova user_name.
    # +project_name+: A String representing a nova project_name name.

    def create user_name, project_name
      modify_role user_name, "add", project_name
    end

    ##
    # Removes the given 'user_name' from the specified "project_name's" 'Role::DEFAULT'.
    #
    # +user_name+: A String representing a nova user_name.
    # +project_name+: A String representing a nova project_name name.

    def destroy user_name, project_name
      modify_role user_name, "remove", project_name
    end

    ##
    # Returns roles for the given 'user_name' and 'project_name'.

    def all user_name, project_name
      params = {
        "User"    => user_name,
        "Project" => project_name
      }

      response = @client.action "DescribeUserRoles", params

      Nephophobia.coerce(response.body['DescribeUserRolesResponse']['roles']['item']).collect do |data|
        RoleData.new data
      end
    end

  private
    def modify_role user_name, operation, project_name
      params = {
        "User"      => user_name,
        "Role"      => Role::DEFAULT,
        "Operation" => operation
      }

      response = @client.action "ModifyUserRole", params

      ResponseData.new response.body['ModifyUserRoleResponse']
    end
  end
end
