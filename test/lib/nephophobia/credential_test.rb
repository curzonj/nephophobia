require 'test_helper'

describe Nephophobia::Credential do
  ##
  # Note:
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @key_name   = "vcr_keypair"
    @credential = ::Client.with(:user).credential
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
end
