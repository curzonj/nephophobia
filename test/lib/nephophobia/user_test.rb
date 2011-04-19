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
    @user         = ::Client.with(:admin,
      :host       => "10.3.170.32",
      :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
      :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e",
      :project    => @project_name
    ).user
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
      @role    = ::Client.with(:admin,
        :host       => "10.3.170.32",
        :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
        :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e",
        :project    => @project_name
      ).role
      @project = ::Client.with(:admin,
        :host       => "10.3.170.32",
        :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
        :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e",
        :project    => @project_name
      ).project

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
