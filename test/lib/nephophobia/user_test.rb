require "test_helper"

describe Nephophobia::User do
  ##
  # Note:
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @user_name    = "vcr_user"
    @project_name = "sandbox"
    @user         = ::Client.with(:admin).user
  end

  describe "#create" do
    before do
      VCR.use_cassette "user_create" do
        @response = @user.create @user_name
      end
    end

    after do
      VCR.use_cassette "user_create" do
        @user.destroy @user_name
      end
    end

    it "creates the user name" do
      VCR.use_cassette "user_create" do
        @response.username.must_equal @user_name
      end
    end
  end

  describe "#credentials" do
    before do
      VCR.use_cassette "user_credentials" do
        @project_one = "foo_project"
        @project_two = "bar_project"
        @client      = ::Client.trunk_with(:admin)

        @client.user.create @user_name
        @client.project.create @project_one, @user_name
        @client.project.create @project_two, @user_name
      end
    end

    after do
      VCR.use_cassette "user_credentials" do
        @client.project.destroy @project_one
        @client.project.destroy @project_two
        @client.user.destroy @user_name
      end
    end

    it "returns the credentials for a given 'user_name' for the specified 'project_name'." do
      VCR.use_cassette "user_credentials" do
        response = @client.user.credentials @user_name, @project_one

        response.must_match %r{BEGIN CERTIFICATE}
        response.must_match %r{:#{@project_one}}
      end
    end
  end

  describe "#destroy" do
    it "destroys the user name" do
      VCR.use_cassette "user_destroy" do
        @user.create @user_name

        response = @user.destroy @user_name

        response.return.must_equal true
      end
    end
  end

  describe "#find" do
    before do
      VCR.use_cassette "user_find" do
        @user.create @user_name

        @response = @user.find @user_name
      end
    end

    after do
      VCR.use_cassette "user_find" do
        @user.destroy @user_name
      end
    end

    it "returns the user name" do
      @response.username.must_equal @user_name
    end

    it "contains the user data" do
      @response.username.must_equal @user_name
      @response.secretkey.must_match %r{[a-z0-9-]+}
      @response.accesskey.must_match %r{[a-z0-9-]+}
    end
  end

  describe "#find with invalid user_name" do
    it "returns nil" do
      VCR.use_cassette "user_find_with_invalid_user_name" do
        @response = @user.find "invalid_user_name"
      end

      @response.must_be_nil
    end
  end

  describe "#register" do
    before do
      @role    = ::Client.with(:admin).role
      @project = ::Client.with(:admin).project

      VCR.use_cassette "user_register" do
        @user.create @user_name

        @response = @user.register @user_name, @project_name
      end
    end

    after do
      VCR.use_cassette "user_register" do
        @user.destroy @user_name
      end
    end

    it "applies a set of global and per-project permissions to user name" do
      VCR.use_cassette "user_register_asserts" do
        @role.all(@user_name).first.name.must_equal "sysadmin"
        @role.all(@user_name, @project_name).first.name.must_equal "sysadmin"
        @project.member?(@user_name, @project_name).must_equal true
      end
    end
  end
end
