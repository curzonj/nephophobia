require "test_helper"

describe Nephophobia::User do
  before { @user = Nephophobia::User.new ADMIN_CLIENT }

  describe "#add_role" do
    before do
      @user_name    = "foobar_user"
      @project_name = "production"
    end

    it "adds the default role to the given 'user_name'" do
      VCR.use_cassette "user_add_role" do
        response = @user.add_role @user_name, @project_name

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end

  describe "#create" do
    before { @user_name = "foobar_user" }

    it "creates the given 'user_name'" do
      VCR.use_cassette "user_create" do
        response = @user.create @user_name

        response.xpath("//xmlns:username").text.must_equal @user_name
      end
    end
  end

  describe "#destroy" do
    before do
      @user_name    = "foobar_user"
      @project_name = "production"
    end

    it "destroys the given 'user_name'" do
      VCR.use_cassette "user_destroy" do
        response = @user.destroy @user_name, @project_name

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end

  describe "#find" do
    before { @user_name = "jdewey" }

    it "returns the given 'user_name'" do
      VCR.use_cassette "user_find" do
        response = @user.find @user_name

        response.xpath("//xmlns:username").text.must_equal @user_name
      end
    end
  end

  describe "#remove_role" do
    before do
      @user_name    = "foobar_user"
      @project_name = "production"
    end

    it "removes the default role to the given 'user_name'" do
      VCR.use_cassette "user_remove_role" do
        response = @user.remove_role @user_name, @project_name

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end
end
