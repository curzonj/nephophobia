require "test_helper"

describe Nephophobia::Image do
  ##
  # Note:
  #   Assumes there is always at least one valid image.
  #   Images need to be manually uploaded with euca2ools
  #   or ogle.
  #
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @image = ::Client.with(:user).image
  end

  describe "#all" do
    it "returns all images" do
      VCR.use_cassette "image_all" do
        response = @image.all

        response.size.must_be :>=, 1
      end
    end

    it "API doesn't implement Filter" do
      VCR.use_cassette "image_all_with_filter" do
        response = @image.all "ExecutableBy.1" => "self"

        response.size.must_be :>=, 1
      end
    end
  end

  describe "#find" do
    ##
    # Note:
    #   Assumes this is a public, runnable, machine type.

    before do
      @image_id = "ami-00000002"

      VCR.use_cassette "image_find" do
        @response = @image.find @image_id
      end
    end

    it "returns the image" do
      @response.image_id.must_equal @image_id
    end

    it "contains the image data" do
      @response.respond_to?(:architecture).must_equal true
      @response.image_id.must_equal @image_id
      @response.image_location.must_match %r{[a-z]+}
      @response.respond_to?(:image_owner_id).must_equal true
      @response.image_type.must_equal "machine"
      @response.is_public.must_equal "true"
      @response.kernel_id.must_match %r{[a-z]+-[0-9]+}
      @response.state.must_equal "available"
    end
  end

  describe "#public" do
    it "returns all public images" do
      VCR.use_cassette "image_all" do
        response = @image.runnable

        response.any? { |i| i.image_type != "kernel"}.must_equal true
      end
    end
  end
end
