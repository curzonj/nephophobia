require "test_helper"

describe Nephophobia::Project do
  before do
    @project      = ::Client.with(:admin).project
    @user         = ::Client.with(:admin).user
    @user_name    = "vcr"
    @project_name = "vcr_project"
  end

  describe "#add_member" do
    before { @project_name = "vcr_secondary_project" }

    it "adds the given 'user_name' to the specified 'project_name'" do
      VCR.use_cassette "project_add_member" do
        response = @project.add_member @user_name, @project_name

        response.return.must_equal true
      end
    end
  end

  describe "#all" do
    it "returns all projects" do
      VCR.use_cassette "project_all" do
        response = @project.all

        response.size.must_equal 5
      end
    end

    it "has a 'TypeError: can't convert String into Integer' error" do
      VCR.use_cassette "project_all_with_string_into_int_error" do
        response = @project.all

        response.size.must_equal 1
      end
    end
  end

  describe "#all with a user_name" do
    it "returns all projects for the given 'user_name'" do
      VCR.use_cassette "project_all_with_with_user_name" do
        response = @project.all @user_name

        response.size.must_equal 1
      end
    end
  end

  describe "#create" do
    it "creates the given 'user_name' in the specified 'project_name'" do
      VCR.use_cassette "project_create" do
        response = @project.create @project_name, @user_name

        response.name.must_equal @project_name
        response.manager_id.must_equal @user_name
      end
    end
  end

  describe "#destroy" do
    it "destroys the given 'project_name'" do
      VCR.use_cassette "project_destroy" do
        response = @project.destroy @project_name

        response.return.must_equal true
      end
    end
  end

  describe "#find" do
    before do
      VCR.use_cassette "project_find" do
        @response = @project.find @project_name
      end
    end

    it "returns the given 'project_name'" do
      @response.name.must_equal @project_name
    end

    it "contains the project data" do
      project = @response

      project.name.must_equal "vcr_project"
      project.manager_id.must_equal "vcr"
      project.description.must_equal "vcr_project"
    end
  end

  describe "#find with invalid project_name" do
    it "rescues Hugs::Errors::BadRequest" do
      VCR.use_cassette "project_find_with_invalid_project_name" do
        @response = @project.find "invalid_project_name"
      end

      @response.must_be_nil
    end
  end

  describe "#members" do
    it "returns all project members for the given 'project_name'" do
      VCR.use_cassette "project_members" do
        response = @project.members @project_name

        response.size.must_equal 2
      end
    end

    it "has a 'TypeError: can't convert String into Integer' error" do
      VCR.use_cassette "project_members_with_string_into_int_error" do
        response = @project.members @project_name

        response.size.must_equal 1
      end
    end
  end

  describe "#members with invalid 'project_name'" do
    it "rescues Hugs::Errors::BadRequest" do
      VCR.use_cassette "project_members_with_invalid_project_name" do
        @response = @project.members "invalid_project_name"
      end

      @response.must_be_nil
    end
  end

  describe "#member?" do
    it "returns true if the given 'user_name' is a member of the specified 'project_name'" do
      VCR.use_cassette "project_members" do
        response = @project.member? @user_name, @project_name

        response.must_equal true
      end
    end
  end

  describe "#remove_member" do
    before { @project_name = "vcr_secondary_project" }

    it "removes the given 'user_name' from the specified 'project_name'" do
      VCR.use_cassette "project_remove_member" do
        response = @project.remove_member @user_name, @project_name

        response.return.must_equal true
      end
    end
  end
end
