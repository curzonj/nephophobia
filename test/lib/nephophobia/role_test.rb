require "test_helper"

describe Nephophobia::Role do
  before do
    @role         = ADMIN_CLIENT.role
    @user_name    = "foobar_user"
    @project_name = "foobar_project"
  end

  describe "#create" do
    it "adds the default role to the given 'user_name'" do
      VCR.use_cassette "role_create" do
        response = @role.create @user_name, @project_name

        response.return.must_equal true
      end
    end
  end

  describe "#destroy" do
    it "removes the default role to the given 'user_name'" do
      VCR.use_cassette "role_destroy" do
        response = @role.destroy @user_name, @project_name

        response.return.must_equal true
      end
    end
  end
end
