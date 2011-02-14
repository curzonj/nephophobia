require "test_helper"

describe AWS do
  describe "::canonical_string" do
    before do
      @params = {"name1" => "value1", "name2" => "value2 has spaces", "name3" => "value3~"}
      @host   = "example.com"
      @port   = 8080
    end

    it "returns a proper path when required signature provided" do
      result = AWS.canonical_string @params, @host, @port

      result.must_equal "POST\nexample.com:8080\n/\nname1=value1&name2=value2%20has%20spaces&name3=value3~"
    end

    it "returns a proper path when optional signature provided" do
      result = AWS.canonical_string @params, @host, @port, "METHOD", "/base"

      result.must_equal "METHOD\nexample.com:8080\n/base\nname1=value1&name2=value2%20has%20spaces&name3=value3~"
    end
  end

  describe "::encode" do
    it "returns a Base64 encoded string" do
      result = AWS.encode "secretaccesskey", "foobar123", false

      result.must_equal "CPzGGhtvlG3P3yp88fPZp0HKouUV8mQK1ZcdFGQeAug="
    end

    it "returns a URL encoded string" do
      result = AWS.encode "secretaccesskey", "foobar123", true

      result.must_equal "CPzGGhtvlG3P3yp88fPZp0HKouUV8mQK1ZcdFGQeAug%3D"
    end
  end
end
