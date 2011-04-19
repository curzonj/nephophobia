require "test_helper"

describe Nephophobia::Role do
  ##
  # Note:
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @user_name    = "vcr_user"
    @project_name = "sandbox"
    @role_name    = "netadmin"
    @role         = ::Client.with(:admin,
      :host       => "10.3.170.32",
      :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
      :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e",
      :project    => @project_name
    ).role
    @user         = ::Client.with(:admin,
      :host       => "10.3.170.32",
      :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
      :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e",
      :project    => @project_name
    ).user
  end

  describe "#all" do
    describe "with 'user_name'" do
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

    describe "without roles" do
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

    describe "with 'user_name' and 'project_name'" do
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
  end

  describe "#create" do
    describe "with 'user_name'" do
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

    describe "with 'user_name' and 'project_name'" do
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

    describe "with 'user_name', 'project_name', and 'role_name'" do
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
  end

  describe "#destroy" do
    describe "with 'user_name'" do
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

    describe "with 'user_name' and 'project_name'" do
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

    describe "with 'user_name', 'project_name', and 'role_name'" do
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
end
