require "test_helper"

describe AWS do
  describe "#signed_params" do
    before do
      @aws = AWS.new(
        :host       => "example.com",
        :port       => 8773,
        :access_key => "9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c",
        :secret_key => "3ae9d9f0-2723-480a-99eb-776f05950506",
        :project    => "production"
      )
    end

    it "returns signed query params" do
      @aws.path = "/services/Cloud"
      result = @aws.signed_params "get", "Action" => "DescribeInstances"

      result.must_equal "AWSAccessKeyId=9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c%3Aproduction&Action=DescribeInstances&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=1999-12-31T19%3A59%3A59Z&Version=2010-11-15&Signature=x0wJmpbCeXpNcwVuTmB7E59zmlyTRkjDxjlO%2BCQi4z4%3D"
    end
  end
end
