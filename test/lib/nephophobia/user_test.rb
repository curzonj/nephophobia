require "test_helper"

describe Nephophobia::User do
  before { @user = Nephophobia::User.new ADMIN_CLIENT }

  describe "#add_role" do
    before do
      @username = "foobar_user"
      @project  = "production"
    end

    it "adds the default role to the given 'username'" do
      VCR.use_cassette "user_add_role" do
        response = @user.add_role @username, @project

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end

  describe "#create" do
    before { @username = "foobar_user" }

    it "creates the given 'username'" do
      VCR.use_cassette "user_create" do
        response = @user.create @username

        response.xpath("//xmlns:username").text.must_equal @username
      end
    end
  end

  describe "#destroy" do
    before do
      @username = "foobar_user"
      @project  = "production"
    end

    it "destroys the given 'username'" do
      VCR.use_cassette "user_destroy" do
        response = @user.destroy @username, @project

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end

  describe "#find" do
    before { @username = "jdewey" }

    it "returns the given 'username'" do
      VCR.use_cassette "user_find" do
        response = @user.find @username

        response.xpath("//xmlns:username").text.must_equal @username
      end
    end
  end

  describe "#remove_role" do
    before do
      @username = "foobar_user"
      @project  = "production"
    end

    it "removes the default role to the given 'username'" do
      VCR.use_cassette "user_remove_role" do
        response = @user.remove_role @username, @project

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end
end
