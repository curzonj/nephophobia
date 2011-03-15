require "test_helper"

describe Hashify do
  #TODO: *WAY* more testing

  describe "::convert" do
    it "creates a hash from a Nokogiri::XML::Document" do
      xml  = cassette_for "compute_all"
      hash = Hashify.convert xml.root

      assert_equal "Server 1189", hash['DescribeInstancesResponse']['reservationSet']['item'].first['instancesSet']['item']['displayName']
      assert_equal "testserver1", hash['DescribeInstancesResponse']['reservationSet']['item'].last['instancesSet']['item']['displayName']
    end
  end
end
