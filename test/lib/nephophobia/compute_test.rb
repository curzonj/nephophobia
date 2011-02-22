require "test_helper"

describe Nephophobia::Compute do
  before { @compute = Nephophobia::Compute.new CLIENT }

  describe "#all" do
    it "returns all instances" do
      VCR.use_cassette "compute_all" do
        response = @compute.all

        response.size.must_equal 6
      end
    end

    # TODO: Filters implemented in OpenStacks cloud.py?
    #it "returns all instances from the given filter" do
    #  VCR.use_cassette "compute_all_with_filter" do
    #    response = @compute.all(
    #      "Filter.1.Name"    => "instance-type",
    #      "Filter.1.Value.1" => "m1.small"
    #    )

    #    puts response #response.size.must_equal 88
    #  end
    #end
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
