require "test_helper"

describe Nephophobia::Role do
  before do
    @role         = ADMIN_CLIENT.role
    @user_name    = "foobar_user"
    @project_name = "foobar_project"
    @role_name    = "netadmin"
  end

  describe "#create" do
    it "adds the default global role to the given 'user_name'" do
      VCR.use_cassette "role_create" do
        response = @role.create @user_name

        response.return.must_equal true
      end
    end

    it "adds the default role to the given 'user_name' and 'project_name'" do
      VCR.use_cassette "role_create_with_project_name" do
        response = @role.create @user_name, @project_name

        response.return.must_equal true
      end
    end

    it "adds the specified 'role_name' to the given 'user_name' and 'project_name'" do
      VCR.use_cassette "role_create_with_project_name_and_role_name" do
        response = @role.create @user_name, @project_name, @role_name

        response.return.must_equal true
      end
    end

  end

  describe "#destroy" do
    it "removes the default global role to the given 'user_name'" do
      VCR.use_cassette "role_destroy" do
        response = @role.destroy @user_name

        response.return.must_equal true
      end
    end

    it "removes the default role to the given 'user_name' and 'project_name'" do
      VCR.use_cassette "role_destroy_with_project_name" do
        response = @role.destroy @user_name, @project_name

        response.return.must_equal true
      end
    end

    it "removes the specified 'role_name' to the given 'user_name' and 'project_name'" do
      VCR.use_cassette "role_destroy_with_project_name_and_role_name" do
        response = @role.destroy @user_name, @project_name, @role_name

        response.return.must_equal true
      end
    end
  end

  describe "#all" do
    it "returns all roles for the given 'user_name' and 'project_name'" do
      VCR.use_cassette "role_all" do
        response = @role.all @user_name, @project_name

        response.size.must_equal 2
      end
    end

    it "has a 'TypeError: can't convert String into Integer' error" do
      VCR.use_cassette "role_all_with_string_into_int_error" do
        response = @role.all @user_name, @project_name

        response.size.must_equal 1
      end
    end

    it "has a 'NoMethodError: undefined method `[]' for nil:NilClass' error" do
      VCR.use_cassette "role_all_with_no_roles" do
        response = @role.all @user_name, @project_name

        response.must_be_nil
      end
    end
  end
end
