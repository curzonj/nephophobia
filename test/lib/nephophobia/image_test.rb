require "test_helper"

describe Nephophobia::Image do
  before do
    @image = Nephophobia::Image.new USER_CLIENT
  end

  describe "#image" do
    it "has image decorator" do
      USER_CLIENT.must_respond_to :image
    end
  end

  describe "#all" do
    before do
      VCR.use_cassette "image_all" do
        @response = @image.all
      end
    end

    it "returns all images" do
      @response.size.must_equal 8
    end

    it "contains the image data" do
      image = @response.first

      image.architecture.must_equal "x86_64"
      image.id.must_equal "ami-d0f0o14c"
      image.image_id.must_equal "ami-d0f0o14c"
      image.image_location.must_equal "ttylinx-bucket/ttylinux-uec-amd64-12.1_2.6.35-22_1-vmlinuz.manifest.xml"
      image.image_owner_id.must_equal "production"
      image.image_type.must_equal "kernel"
      image.kernel_id.must_equal "true"
      image.is_public.must_equal "false"
      image.state.must_be_nil
    end

    it "API doesn't implement Filter" do
      VCR.use_cassette "image_all_with_filter" do
        response = @image.all "ExecutableBy.1" => "self"

        response.size.must_equal 8
      end
    end
  end

  describe "#find" do
    before { @image_id = "ami-l1u1pqfm" }

    it "returns the given 'image_id'" do
      VCR.use_cassette "image_find" do
        response = @image.find @image_id

        response.image_id.must_equal @image_id
      end
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
