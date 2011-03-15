require "test_helper"

describe Nephophobia::Image do
  before do
    @image = ::Client.with(:user,
    :access_key => "57c971e9-0225-4fa4-8969-60b880e9f827",
    :secret_key => "86a6a123-2d11-4e99-9931-20b01f6fb236",
    :project => "vcr_project").image
  end

  describe "#all" do
    it "returns all images" do
      VCR.use_cassette "image_all" do
        response = @image.all

        response.size.must_equal 10
      end
    end

    it "API doesn't implement Filter" do
      VCR.use_cassette "image_all_with_filter" do
        response = @image.all "ExecutableBy.1" => "self"

        response.size.must_equal 10
      end
    end

    it "has a 'TypeError: can't convert String into Integer' error" do
      VCR.use_cassette "image_all_with_string_into_int_error" do
        response = @image.all

        response.size.must_equal 1
      end
    end
  end

  describe "#find" do
    before do
      @image_id = "ami-d0f0o14c"

      VCR.use_cassette "image_find" do
        @response = @image.find @image_id
      end
    end

    it "returns the given 'image_id'" do
      @response.image_id.must_equal @image_id
    end

    it "contains the image data" do
      image = @response

      image.architecture.must_equal "x86_64"
      image.image_id.must_equal @image_id
      image.image_location.must_equal "ttylinx-bucket/ttylinux-uec-amd64-12.1_2.6.35-22_1-vmlinuz.manifest.xml"
      image.image_owner_id.must_equal "production"
      image.image_type.must_equal "kernel"
      image.is_public.must_equal "false"
      image.kernel_id.must_equal "true"
      image.state.must_equal "available"
    end
  end

  describe "#public" do
    it "returns all public images" do
      VCR.use_cassette "image_all" do
        response = @image.public

        response.size.must_equal 1
      end
    end
  end
end
