require "test_helper"

describe Nephophobia::Compute do
  before { @compute = Nephophobia::Compute.new USER_CLIENT }

  describe "#all" do
    it "returns all instances" do
      VCR.use_cassette "compute_all" do
        response = @compute.all

        response.size.must_equal 6
      end
    end

    # TODO: RackSpace EC2 Filters un-implemented in OpenStack.
    it "is a pointless test displaying the unimplemented filter" do
      VCR.use_cassette "compute_all_with_filter" do
        filter = {
          "Filter.1.Name"    => "instance-type",
          "Filter.1.Value.1" => "m1.small"
        }

        lambda { @compute.all filter }.must_raise Hugs::Errors::BadRequest
      end
    end
  end

  describe "#destroy" do
    before { @instance_id = "i-000000c7" }

    it "destroy the given 'instance_id'" do
      VCR.use_cassette "compute_destroy" do
        response = @compute.destroy @instance_id

        response.xpath("//xmlns:return").text.must_equal "true"
      end
    end
  end

  describe "#find" do
    before { @instance_id = "i-000000c7" }

    it "returns the given 'instance_id'" do
      VCR.use_cassette "compute_find" do
        response = @compute.find @instance_id

        response.xpath("//xmlns:instanceId").text.must_equal @instance_id
      end
    end
  end
end
