require "test_helper"

describe Nephophobia::Resource::Role do
  ##
  # Note:
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @user_name    = "vcr_user"
    @project_name = "sandbox"
    @role_name    = "netadmin"
    @role         = ::Client.with(:admin).role
    @user         = ::Client.with(:admin).user
  end

  describe "#all with a 'user_name'" do
    before do
      VCR.use_cassette "role_all" do
        @user.create @user_name
        @role.create @user_name

        @response = @role.all @user_name
      end
    end

    after do
      VCR.use_cassette "role_all" do
        @user.destroy @user_name
        @role.destroy @user_name
      end
    end

    it "returns all roles" do
      VCR.use_cassette "role_all" do
        @response.size.must_be :>=, 1
      end
    end
  end

  describe "#all without roles" do
    before do
      VCR.use_cassette "role_all_without_roles" do
        @user.create @user_name

        @response = @role.all @user_name
      end
    end

    after do
      VCR.use_cassette "role_all_without_roles" do
        @user.destroy @user_name
        @role.destroy @user_name
      end
    end

    it "returns all roles" do
      @response.must_be_nil
    end
  end

  describe "#all with 'user_name' and 'project_name'" do
    before do
      VCR.use_cassette "role_all_with_project_name" do
        @user.create @user_name
        @role.create @user_name, @project_name

        @response = @role.all @user_name, @project_name
      end
    end

    after do
      VCR.use_cassette "role_all_with_project_name" do
        @user.destroy @user_name
        @role.destroy @user_name, @project_name
      end
    end

    it "returns all roles" do
      @response.size.must_be :>=, 1
    end
  end

  describe "#create with a 'user_name'" do
    before do
      VCR.use_cassette "role_create" do
        @user.create @user_name

        @response = @role.create @user_name
      end
    end

    after do
      VCR.use_cassette "role_create" do
        @user.destroy @user_name
        @role.destroy @user_name
      end
    end

    it "adds role" do
      @response.return.must_equal true
    end
  end

  describe "#modify_role" do
    before do
      VCR.use_cassette "role_modify_role" do
        @user.create @user_name
      end
    end

    after do
      VCR.use_cassette "role_modify_role" do
        @user.destroy @user_name
      end
    end

    it "allows adding and deleting of roles" do
      VCR.use_cassette "role_modify_role" do
        @role.modify_role @user_name, 'add', @project_name, 'sysadmin'
        @role.modify_role @user_name, 'add', @project_name, 'netadmin'
        roles = @role.all(@user_name, @project_name).collect(&:name)
        roles.size.must_equal 2
        roles.must_include 'sysadmin'
        roles.must_include 'netadmin'
        @role.modify_role @user_name, 'remove', @project_name, 'sysadmin'
        roles = @role.all(@user_name, @project_name).collect(&:name)
        roles.size.must_equal 1
        roles.must_include 'netadmin'
      end
    end
  end

  describe "#create with 'user_name' and 'project_name'" do
    before do
      VCR.use_cassette "role_create_with_project_name" do
        @user.create @user_name

        @response = @role.create @user_name, @project_name
      end
    end

    after do
      VCR.use_cassette "role_create_with_project_name" do
        @user.destroy @user_name
        @role.destroy @user_name, @project_name
      end
    end

    it "adds role" do
      @response.return.must_equal true
    end
  end

  describe "#create with 'user_name', 'project_name', and 'role_name'" do
    before do
      VCR.use_cassette "role_create_with_project_name_and_role_name" do
        @user.create @user_name

        @response = @role.create @user_name, @project_name, @role_name
      end
    end

    after do
      VCR.use_cassette "role_create_with_project_name_and_role_name" do
        @user.destroy @user_name
        @role.destroy @user_name, @project_name, @role_name
      end
    end

    it "adds role" do
      @response.return.must_equal true
    end
  end

  describe "#destroy with 'user_name'" do
    before do
      VCR.use_cassette "role_destroy" do
        @user.create @user_name
        @role.create @user_name

        @response = @role.destroy @user_name
      end
    end

    after do
      VCR.use_cassette "role_destroy" do
        @user.destroy @user_name
      end
    end

    it "removes role" do
      @response.return.must_equal true
    end
  end

  describe "#destroy with 'user_name' and 'project_name'" do
    before do
      VCR.use_cassette "role_destroy_with_project_name" do
        @user.create @user_name
        @role.create @user_name, @project_name

        @response = @role.destroy @user_name, @project_name
      end
    end

    after do
      VCR.use_cassette "role_destroy_with_project_name" do
        @user.destroy @user_name
      end
    end

    it "removes role" do
      @response.return.must_equal true
    end
  end

  describe "#destroy with 'user_name', 'project_name', and 'role_name'" do
    before do
      VCR.use_cassette "role_destroy_with_project_name_and_role_name" do
        @user.create @user_name
        @role.create @user_name, @project_name, @role_name

        @response = @role.destroy @user_name, @project_name, @role_name
      end
    end

    after do
      VCR.use_cassette "role_destroy_with_project_name_and_role_name" do
        @user.destroy @user_name
      end
    end

    it "removes role" do
      @response.return.must_equal true
    end
  end
end
