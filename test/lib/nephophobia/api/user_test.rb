require "test_helper"

describe Nephophobia::API::User do
  before do
    @user         = Nephophobia::API::User.new ADMIN_CLIENT
    @user_name    = "foobar_user"
    @project_name = "foobar_project"
  end

  describe "#add_role" do
    it "adds the default role to the given 'user_name'" do
      VCR.use_cassette "user_add_role" do
        response = @user.add_role @user_name, @project_name

        response['return'].must_equal "true"
      end
    end
  end

  describe "#create" do
    it "creates the given 'user_name'" do
      VCR.use_cassette "user_create" do
        response = @user.create @user_name

        response['username'].must_equal @user_name
      end
    end
  end

  describe "#destroy" do
    it "destroys the given 'user_name'" do
      VCR.use_cassette "user_destroy" do
        response = @user.destroy @user_name

        response['return'].must_equal "true"
      end
    end
  end

  describe "#find" do
    before { @user_name = "jdewey" }

    it "returns the given 'user_name'" do
      VCR.use_cassette "user_find" do
        response = @user.find @user_name

        response['username'].must_equal @user_name
      end
    end
  end

  describe "#remove_role" do
    it "removes the default role to the given 'user_name'" do
      VCR.use_cassette "user_remove_role" do
        response = @user.remove_role @user_name, @project_name

        response['return'].must_equal "true"
      end
    end
  end
end
