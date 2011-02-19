require "test_helper"

describe Nephophobia::Compute do
  describe "#describe_instances" do
    it "returns a Nokogiri::XML::Document" do
      VCR.use_cassette "describe_instances" do
        response = CLIENT.compute.describe_instances

        response.body.must_be_kind_of Nokogiri::XML::Document
      end
    end
  end
end
