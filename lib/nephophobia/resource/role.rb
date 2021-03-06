##
# __Must__ execute as a user with the +admin+ role.

module Nephophobia
  module Resource
    class Role
      DEFAULT = "sysadmin"

      def initialize client
        @client = client
      end

      ##
      # Returns global roles for the given 'user_name', or for the given 'project_name'.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: An Optional String representing a nova project_name name.

      def all user_name=nil, project_name = nil
        params = {}
        params.merge!("User" => user_name) if user_name
        params.merge!("Project" => project_name) if project_name
        action = ( user_name ? "DescribeUserRoles" : "DescribeRoles" )

        response = @client.action action, params

        roles = response.body["#{action}Response"]['roles']
        roles && Nephophobia::Util.coerce(roles['item']).collect do |data|
          Response::Role.new data
        end
      end

      ##
      # Adds the given 'user_name' to the global 'Role::DEFAULT', unless a
      # 'role_name' is provided.
      # Returns a response to the state change.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: An Optional String representing a nova project_name name.
      # +role_name+: An Optional String representing a nova role name.

      def create user_name, project_name = nil, role_name = nil
        modify_role user_name, "add", project_name, role_name
      end

      ##
      # Removes the given 'user_name' from the global 'Role::DEFAULT', unless a
      # 'role_name' is provided.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: An Optional String representing a nova project_name name.
      # +role_name+: An Optional String representing a nova role name.

      def destroy user_name, project_name = nil, role_name = nil
        modify_role user_name, "remove", project_name
      end

      def modify_role user_name, operation, project_name = nil, role_name = nil
        params = {
          "User"      => user_name,
          "Role"      => role_name || DEFAULT,
          "Operation" => operation
        }
        params.merge!("Project" => project_name) if project_name

        response = @client.action "ModifyUserRole", params

        Response::Return.new response.body['ModifyUserRoleResponse']
      end
    end
  end
end
