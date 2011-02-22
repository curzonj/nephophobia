require "test_helper"

describe Nephophobia::Image do
  before { @image = Nephophobia::Image.new USER_CLIENT }

  describe "#all" do
    it "returns all images" do
      VCR.use_cassette "image_all" do
        response = @image.all

        response.size.must_equal 8
      end
    end

    # TODO: Filters implemented in OpenStacks cloud.py?
    #it "returns all images from the given filter" do
    #  VCR.use_cassette "image_all_with_filter" do
    #    response = @image.all(
    #      "ExecutableBy.1" => "self"
    #    )

    #    puts response #response.size.must_equal 88
    #  end
    #end
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
