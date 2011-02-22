require "test_helper"

describe Nephophobia::Project do
  before do
    @project = Nephophobia::Project.new ADMIN_CLIENT
    @user    = Nephophobia::User.new ADMIN_CLIENT
  end

  describe "#add_member" do
    before do
      @user_name    = "foobar_user"
      @project_name = "production"
    end

    it "adds the given 'user_name' to the specified 'project_name'" do
      VCR.use_cassette "user_add_memeber" do
        response = @project.add_member @user_name, @project_name

        response.xpath("//xmlns:return").text.must_equal "true"
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
    before do 
      @project_name = "foobar_project"
      @user_name    = "foobar_user"
    end

    it "creates the given 'project_name'" do
      VCR.use_cassette "project_create" do
        @user.create @user_name
        response = @project.create @project_name, @user_name

        response.xpath("//xmlns:projectname").text.must_equal @project_name
        response.xpath("//xmlns:projectManagerId").text.must_equal @user_name
      end
    end
  end

  describe "#destroy" do
    before do
      @project_name = "foobar_project"
    end

    it "destroys the given 'project_name'" do
      VCR.use_cassette "project_destroy" do
        response = @project.destroy @project_name

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end

  describe "#find" do
    before { @project_name = "production" }

    it "returns the given 'project_name'" do
      VCR.use_cassette "project_find" do
        response = @project.find @project_name

        response.xpath("//xmlns:projectname").text.must_equal @project_name
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
    before do
      @user_name    = "foobar_user"
      @project_name = "production"
    end

    it "removes the given 'user_name' from the specified 'project_name'" do
      VCR.use_cassette "user_remove_member" do
        response = @user.remove_role @user_name, @project_name

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end
end
