module Nephophobia
  class ProjectData
    attr_reader :name, :manager_id, :description, :member

    def initialize hash
      @name        = hash['projectname']
      @manager_id  = hash['projectManagerId']
      @description = hash['description']
      @member      = hash['member']
    end
  end

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

    def all
      response = @client.action "DescribeProjects", {}

      Nephophobia.coerce(response.body['DescribeProjectsResponse']['projectSet']['item']).collect do |data|
        ProjectData.new data
      end
    end

    ##
    # Creates the given 'project_name' and adds the specified 'user_name' as the manager.
    # Returns a response to the state change.
    #
    # +user_name+: A String representing a nova user_name.
    # +project_name+: A String representing a nova project name.

    def create project_name, user_name
      filter = {
        "Name"        => project_name,
        "ManagerUser" => user_name
      }

      response = @client.action "RegisterProject", filter

      ProjectData.new response.body['RegisterProjectResponse']
    end

    ##
    # Removes the given 'project_name'.
    # Returns a response to the state change.
    #
    # +project_name+: A String representing a nova project name.

    def destroy project_name
      response = @client.action "DeregisterProject", "Name" => project_name

      ResponseData.new response.body['DeregisterProjectResponse']
    end

    ##
    # Returns information about the given 'project_name'.
    #
    # +project_name+: A String representing a nova project name.

    def find project_name
      response = @client.action "DescribeProject", "Name" => project_name

      ProjectData.new response.body['DescribeProjectResponse']
    rescue Hugs::Errors::BadRequest
    end

    ##
    # Returns information about all members of the given 'project_name'.
    #
    # +project_name+: A String representing a nova project name.

    def members project_name
      response = @client.action "DescribeProjectMembers", "Name" => project_name

      response.body['DescribeProjectMembersResponse']['members']['item'].collect do |data|
        ProjectData.new data
      end
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

      ResponseData.new response.body['ModifyProjectMemberResponse']
    end
  end
end
