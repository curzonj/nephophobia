require "test_helper"

describe AWS do
  describe "#signed_params" do
    before do
      @aws = AWS.new(
        :host       => "example.com",
        :port       => 8773,
        :path       => "/services/Cloud",
        :access_key => "9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c",
        :secret_key => "3ae9d9f0-2723-480a-99eb-776f05950506",
        :project    => "production"
      )
    end

    it "returns signed query params" do
      result = @aws.signed_params "get", "Action" => "DescribeInstances"

      result.must_equal "AWSAccessKeyId=9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c%3Aproduction&Action=DescribeInstances&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2011-02-19T07%3A17%3A56Z&Version=2010-08-31&Signature=rw4KU2oHC5rR1jpDeLDjiYrm86w48%2F2FaAcxOfI7hQA%3D"
    end
  end
end
