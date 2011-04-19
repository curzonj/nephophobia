require "test_helper"

describe Nephophobia::Project do
  ##
  # Note:
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @user_name    = "vcr_user"
    @project_name = "sandbox"
    @project      = ::Client.with(:admin,
      :host       => "10.3.170.32",
      :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
      :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e",
      :project    => @project_name
    ).project
    @user         = ::Client.with(:admin,
      :host       => "10.3.170.32",
      :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
      :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e",
      :project    => @project_name
    ).user
  end

  describe "#add_member" do
    before do
      VCR.use_cassette "project_add_member" do
        @user.create @user_name

        @response = @project.add_member @user_name, @project_name
      end
    end

    after do
      VCR.use_cassette "project_add_member" do
        @project.remove_member @user_name, @project_name
        @user.destroy @user_name
      end
    end

    it "adds the given user name to the project" do
      @response.return.must_equal true
    end
  end

  describe "#all" do
    it "returns all projects" do
      VCR.use_cassette "project_all" do
        response = @project.all

        response.size.must_be :>=, 1
      end
    end
  end

  describe "#all with a 'user_name'" do
    before do
      VCR.use_cassette "project_all_with_user_name" do
        @user.create @user_name
        @project.add_member @user_name, @project_name

        @response = @project.all @user_name
      end
    end

    after do
      VCR.use_cassette "project_all_with_user_name" do
        @project.remove_member @user_name, @project_name
        @user.destroy @user_name
      end
    end

    it "returns all projects" do
      @response.size.must_be :>=, 1
    end
  end

  describe "#create" do
    before do
      VCR.use_cassette "project_create" do
        @project_name = "vcr_project"
        @user.create @user_name

        @response = @project.create @project_name, @user_name
      end
    end

    after do
      VCR.use_cassette "project_create" do
        @user.destroy @user_name
        @project.destroy @project_name
      end
    end

    it "creates the project and adds the user name as the manager" do
      @response.name.must_equal @project_name
      @response.manager_id.must_equal @user_name
    end
  end

  describe "#destroy" do
    before do
      VCR.use_cassette "project_destroy" do
        @project_name = "vcr_project"
        @user.create @user_name
        @project.create @project_name, @user_name

        @response = @project.destroy @project_name
      end
    end

    after do
      VCR.use_cassette "project_destroy" do
        @user.destroy @user_name
      end
    end

    it "destroys the project" do
      @response.return.must_equal true
    end
  end

  describe "#find" do
    before do
      VCR.use_cassette "project_find" do
        @response = @project.find @project_name
      end
    end

    it "returns the project" do
      @response.name.must_equal @project_name
    end

    it "contains the project data" do
      @response.name.must_equal @project_name
      @response.manager_id.must_match %r{[a-z]+}
      @response.description.must_equal @project_name
    end
  end

  describe "#find with invalid project_name" do
    it "returns nil" do
      VCR.use_cassette "project_find_with_invalid_project_name" do
        @response = @project.find "invalid_project_name"
      end

      @response.must_be_nil
    end
  end

  describe "#members" do
    before do
      VCR.use_cassette "project_members" do
        @user.create @user_name

        @response = @project.members @project_name
      end
    end

    after do
      VCR.use_cassette "project_members" do
        @user.destroy @user_name
      end
    end

    it "returns all project members for the project" do
      @response.size.must_be :>=, 1
    end
  end

  describe "#members with invalid 'project_name'" do
    it "returns nil" do
      VCR.use_cassette "project_members_with_invalid_project_name" do
        @response = @project.members "invalid_project_name"
      end

      @response.must_be_nil
    end
  end

  describe "#member?" do
    before do
      VCR.use_cassette "project_member" do
        @user.create @user_name
        @project.add_member @user_name, @project_name

        @response = @project.member? @user_name, @project_name
      end
    end

    after do
      VCR.use_cassette "project_member" do
        @project.remove_member @user_name, @project_name
        @user.destroy @user_name
      end
    end

    it "returns true if the user name is a member of the project" do
      @response.must_equal true
    end
  end

  describe "#remove_member" do
    before do
      VCR.use_cassette "project_remove_member" do
        @user.create @user_name
        @project.add_member @user_name, @project_name

        @response = @project.remove_member @user_name, @project_name
      end
    end

    after do
      VCR.use_cassette "project_remove_member" do
        @user.destroy @user_name
      end
    end

    it "removes the user name from the specified project" do
      @response.return.must_equal true
    end
  end
end
