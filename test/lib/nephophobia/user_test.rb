require "test_helper"

describe Nephophobia::User do
  before do
    @user      = ADMIN_CLIENT.user
    @user_name = "foobar_user"
  end

  describe "#create" do
    it "creates the given 'user_name'" do
      VCR.use_cassette "user_create" do
        response = @user.create @user_name

        response.username.must_equal @user_name
      end
    end
  end

  describe "#credentials" do
    before { @project_name = "production" }

    it "returns the credentials for a given 'user_name' for the specified 'project_name'." do
      VCR.use_cassette "user_credentials" do
        response = @user.credentials @user_name, @project_name

        response.must_match %r{BEGIN CERTIFICATE}
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
      @user_name = "jdewey"

      VCR.use_cassette "user_find" do
        @response = @user.find @user_name
      end
    end

    it "returns the given 'user_name'" do
      @response.username.must_equal @user_name
    end

    it "contains the user data" do
      user = @response

      user.username.must_equal "jdewey"
      user.secretkey.must_equal "3ae9d9f0-2723-480a-99eb-776f05950506"
      user.accesskey.must_equal "9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c"
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
end
