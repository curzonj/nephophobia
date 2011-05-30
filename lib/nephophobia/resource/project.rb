##
# __Must__ execute as a user with the +admin+ role.

module Nephophobia
  module Resource
    class Project
      def initialize client
        @client = client
      end

      ##
      # Adds the given 'user_name' to the specified 'project_name'.
      # Returns a response to the state change.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: A String representing a nova project_name name.

      def add_member user_name, project_name
        modify_membership user_name, "add", project_name
      end

      ##
      # Returns information about all projects, or all projects the given
      # 'user_name' is in.
      #
      # +user_name+: An optional String representing a nova user_name.

      def all user_name = nil
        response = @client.action "DescribeProjects", {}

        item     = response.body['DescribeProjectsResponse']['projectSet']['item']
        projects = Nephophobia.coerce(item).collect do |data|
          Response::Project.new data
        end

        return projects unless user_name
        projects.map { |project| project if @client.project.member? user_name, project.name }.compact
      end

      ##
      # Creates the given 'project_name' and adds the specified 'user_name' as the manager.
      # Returns a response to the state change.
      #
      # +project_name+: A String representing a nova project name.
      # +user_name+: A String representing a nova user_name.

      def create project_name, user_name
        params = {
          "Name"        => project_name,
          "ManagerUser" => user_name
        }

        response = @client.action "RegisterProject", params

        Response::Project.new response.body['RegisterProjectResponse']
      end

      ##
      # Removes the given 'project_name'.
      # Returns a response to the state change.
      #
      # +project_name+: A String representing a nova project name.

      def destroy project_name
        response = @client.action "DeregisterProject", "Name" => project_name

        Response::Return.new response.body['DeregisterProjectResponse']
      end

      ##
      # Returns information about the given 'project_name'.
      #
      # +project_name+: A String representing a nova project name.

      def find project_name
        response = @client.action "DescribeProject", "Name" => project_name

        Response::Project.new response.body['DescribeProjectResponse']
      rescue Hugs::Errors::BadRequest
      end

      ##
      # Returns information about all members of the given 'project_name'.
      #
      # +project_name+: A String representing a nova project name.

      def members project_name
        response = @client.action "DescribeProjectMembers", "Name" => project_name

        item = response.body['DescribeProjectMembersResponse']['members']['item']
        Nephophobia.coerce(item).collect do |data|
          Response::Member.new data
        end
      rescue Hugs::Errors::BadRequest
      end

      ##
      # Return a Boolean if the given 'user_name' is a member of the specified 'project_name'.
      #
      # +user_name+: A String representing a nova user_name.
      # +project_name+: A String representing a nova project_name name.

      def member? user_name, project_name
        members(project_name).any? { |f| f.member == user_name }
      end

      ##
      # Removes the given 'user_name' from the specified 'project_name'.
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

        Response::Return.new response.body['ModifyProjectMemberResponse']
      end
    end
  end
end
