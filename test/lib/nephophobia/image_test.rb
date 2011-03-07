require "test_helper"

describe Nephophobia::Image do
  before { @image = USER_CLIENT.image }

  describe "#all" do
    it "returns all images" do
      VCR.use_cassette "image_all" do
        response = @image.all

        response.size.must_equal 8
      end
    end

    it "API doesn't implement Filter" do
      VCR.use_cassette "image_all_with_filter" do
        response = @image.all "ExecutableBy.1" => "self"

        response.size.must_equal 8
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
      @image_id = "ami-l1u1pqfm"

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
      image.image_id.must_equal "ami-l1u1pqfm"
      image.image_location.must_equal "ttylinx-bucket/ttylinux-uec-amd64-12.1_2.6.35-22_1.img.manifest.xml"
      image.image_owner_id.must_equal "production"
      image.image_type.must_equal "machine"
      image.is_public.must_equal "false"
      image.kernel_id.must_equal "ami-d0f0o14c"
      image.state.must_equal "available"
    end
  end

  describe "#public" do
    it "returns all public images" do
      VCR.use_cassette "image_all" do
        response = @image.public

        response.size.must_equal 2
      end
    end
  end
end
