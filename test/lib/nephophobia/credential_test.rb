require 'test_helper'

describe Nephophobia::Credential do
  ##
  # Note:
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @key_name     = "vcr_keypair"
    @project_name = "sandbox"
    @credential   = ::Client.with(:user).credential
  end

  describe "#all" do
    describe "with keys" do
      before do
        VCR.use_cassette "credential_all" do
          @credential.create @key_name

          @response = @credential.all
        end
      end

      after do
        VCR.use_cassette "credential_all" do
          @credential.destroy @key_name
        end
      end

      it "returns all keys" do
        @response.size.must_be :>=, 1
      end
    end

    describe "without keys" do
      it "returns all keys" do
        VCR.use_cassette "credential_all_without_keys" do
          response = @credential.all

          response.must_be_nil
        end
      end
    end
  end

  describe "#create" do
    before do
      VCR.use_cassette "credential_create" do
        @response = @credential.create @key_name
      end
    end

    after do
      VCR.use_cassette "credential_create" do
        @credential.destroy @key_name
      end
    end

    it "creates a key pair for the key name" do
      @response.material.must_match %r{BEGIN RSA PRIVATE KEY.*END RSA PRIVATE KEY}m
    end
  end

  describe "#destroy" do
    before do
      VCR.use_cassette "credential_destroy" do
        @credential.create @key_name

        @response = @credential.destroy @key_name
      end
    end

    it "deletes the key pair for the key name" do
      @response.return.must_equal true
    end
  end

  describe "#download" do
    before do
      VCR.use_cassette "credential_download" do
        @client = ::Client.with(:admin,
          :access_key => "2ea76797-229c-4e52-a21b-f30513cb91a6",
          :secret_key => "3d16b391-820f-4f5c-893b-0f65d5f35312",
          :host       => "10.3.170.35",
          :project    => "sandbox"
        )

        @uname = 'jsmith'
        @client.user.create 'jsmith'
        @client.project.create 'myproj1', 'jsmith'
        @client.project.create 'myproj2', 'jsmith'
      end
    end

    after do
      VCR.use_cassette "credential_download" do
        @client.project.destroy 'myproj1'
        @client.project.destroy 'myproj2'
        @client.user.destroy 'jsmith'
      end
    end

    it "returns the credentials for a given 'user_name' for the specified 'project_name'." do
      VCR.use_cassette "credential_download" do
        @client.project.members('myproj1')[0].member.must_equal @uname
        @client.project.members('myproj2')[0].member.must_equal @uname
        response = @client.admin_credential.download @uname, @project_name
        response.must_match %r{BEGIN CERTIFICATE}
      end
    end
  end
end
