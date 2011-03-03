require "test_helper"

describe Nephophobia::API::Project do
  before do
    @project      = Nephophobia::API::Project.new ADMIN_CLIENT
    @user         = Nephophobia::API::User.new ADMIN_CLIENT
    @user_name    = "foobar_user"
    @project_name = "foobar_project"
  end

  describe "#add_member" do
    it "adds the given 'user_name' to the specified 'project_name'" do
      VCR.use_cassette "project_add_member" do
        response = @project.add_member @user_name, @project_name

        response['return'].must_equal "true"
      end
    end
  end

  describe "#all" do
    it "returns all projects" do
      VCR.use_cassette "project_all" do
        response = @project.all

        response.size.must_equal 4
      end
    end
  end

  describe "#create" do
    it "creates the given 'project_name'" do
      VCR.use_cassette "project_create" do
        response = @project.create @project_name, @user_name

        response['projectname'].must_equal @project_name
        response['projectManagerId'].must_equal @user_name
      end
    end
  end

  describe "#destroy" do

    it "destroys the given 'project_name'" do
      VCR.use_cassette "project_destroy" do
        response = @project.destroy @project_name

        response['return'].must_equal "true"
      end
    end
  end

  describe "#find" do
    before { @project_name = "production" }

    it "returns the given 'project_name'" do
      VCR.use_cassette "project_find" do
        response = @project.find @project_name

        response['projectname'].must_equal @project_name
      end
    end
  end

  describe "#members" do
    before { @project_name = "production" }

    it "returns all project members for the given 'project_name'" do
      VCR.use_cassette "project_members" do
        response = @project.members @project_name

        response.size.must_equal 11
      end
    end
  end

  describe "#remove_member" do
    it "removes the given 'user_name' from the specified 'project_name'" do
      VCR.use_cassette "project_remove_member" do
        response = @project.remove_member @user_name, @project_name

        response['return'].must_equal "true"
      end
    end
  end
end
