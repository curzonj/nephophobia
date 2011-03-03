module Nephophobia
  module API
    class Project
      def initialize client
        @client = client
      end

      ##
      # Adds the given 'user_name' to the specified "project_name".
      # Returns a response to the state change.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: A String representing a nova project_name name.

      def add_member user_name, project_name
        modify_membership user_name, "add", project_name
      end

      ##
      # Returns information about all projects.

      def all params = {}
        response = @client.action "DescribeProjects", params

        response.body['DescribeProjectsResponse']['projectSet']['item']
      end

      ##
      # Creates the given 'project_name'.
      # Returns a response to the state change.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: A String representing a nova project name.

      def create project_name, user_name
        params = {
          "Name"        => project_name,
          "ManagerUser" => user_name
        }

        response = @client.action "RegisterProject", params

        response.body['RegisterProjectResponse']
      end

      ##
      # Removes the given 'project_name'.
      # Returns a response to the state change.
      #
      # +project_name+: A String representing a nova project name.

      def destroy project_name
        response = @client.action "DeregisterProject", "Name" => project_name

        response.body['DeregisterProjectResponse']
      end

      ##
      # Returns information about the given 'project_name'.
      #
      # +project_name+: A String representing a nova project name.

      def find project_name
        response = @client.action "DescribeProject", "Name" => project_name

        response.body['DescribeProjectResponse']
      end

      ##
      # Returns information about all members of the given 'project_name'.

      def members project_name
        response = @client.action "DescribeProjectMembers", "Name" => project_name

        response.body['DescribeProjectMembersResponse']['members']['item']
      end

      ##
      # Removes the given 'user_name' from the specified "project_name".
      # Returns a response to the state change.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: A String representing a nova project_name name.

      def remove_member user_name, project_name
        modify_membership user_name, "remove", project_name
      end

    private
      def modify_membership user_name, operation, project_name
        params = {
          "User"      => user_name,
          "Project"   => project_name,
          "Operation" => operation
        }

        response = @client.action "ModifyProjectMember", params

        response.body['ModifyProjectMemberResponse']
      end
    end
  end
end
