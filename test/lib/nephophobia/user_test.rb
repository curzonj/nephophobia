require "test_helper"

describe Nephophobia::User do
  before do
    @user      = ::Client.with(:admin).user
    @user_name = "vcr"
  end

  describe "#create" do
    it "creates the given 'user_name'" do
      VCR.use_cassette "user_create" do
        response = @user.create @user_name

        response.username.must_equal @user_name
      end
    end
  end

  describe "#destroy" do
    it "destroys the given 'user_name'" do
      VCR.use_cassette "user_destroy" do
        response = @user.destroy @user_name

        response.return.must_equal true
      end
    end
  end

  describe "#find" do
    before do
      VCR.use_cassette "user_find" do
        @response = @user.find @user_name
      end
    end

    it "returns the given 'user_name'" do
      @response.username.must_equal @user_name
    end

    it "contains the user data" do
      user = @response

      user.username.must_equal "vcr"
      user.secretkey.must_equal "a0d9ff15-2b76-416c-b6fb-03f63c4b8413"
      user.accesskey.must_equal "285db1a2-4c3b-4f35-a36f-1e5495fa94f2"
    end
  end

  describe "#find with invalid user_name" do
    it "rescues Hugs::Errors::BadRequest" do
      VCR.use_cassette "user_find_with_invalid_user_name" do
        @response = @user.find "invalid_user_name"
      end

      @response.must_be_nil
    end
  end

  describe "#register" do
    before do
      @project_name = "vcr_project"
      @role         = ::Client.with(:admin).role
      @project      = ::Client.with(:admin).project
    end

    it "applies a set of global and per-project permissions to the given 'user_name'" do
      VCR.use_cassette "user_register" do
        @response = @user.register @user_name, @project_name
      end

      VCR.use_cassette "user_register_assert" do
        @role.all(@user_name).first.name.must_equal "sysadmin"
        @role.all(@user_name, @project_name).first.name.must_equal "sysadmin"
        @project.member?(@user_name, @project_name).must_equal true
      end
    end
  end
end
