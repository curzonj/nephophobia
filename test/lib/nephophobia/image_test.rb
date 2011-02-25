require "test_helper"

describe Nephophobia::Image do
  before do
    @image = Nephophobia::Image.new USER_CLIENT
    @total = 8
  end

  describe "#all" do
    it "returns all images" do
      VCR.use_cassette "image_all" do
        response = @image.all

        response.size.must_equal @total
      end
    end

    # TODO: RackSpace EC2 Filters un-implemented in OpenStack.
    it "is a pointless test displaying the unimplemented filter" do
      VCR.use_cassette "image_all_with_filter" do
        response = @image.all "ExecutableBy.1" => "self"

        response.size.must_equal @total
      end
    end
  end

  describe "#find" do
    before { @image_id = "ami-l1u1pqfm" }

    it "returns the given 'image_id'" do
      VCR.use_cassette "image_find" do
        response = @image.find @image_id

        response.xpath("//xmlns:imageId").text.must_equal @image_id
      end
    end
  end
end