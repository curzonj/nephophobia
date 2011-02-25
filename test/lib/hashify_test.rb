require "test_helper"

describe Hashify do
  describe "#convert" do
    it "creates a hash from a Nokogiri::XML::Document" do
      xml  = cassette_for "compute_all"
      hash = Hashify.convert xml.root

      assert_equals "Server 199", hash['DescribeInstancesResponse']['reservationSet']['instancesSet']['item']['displayName']
    end
  end
end
