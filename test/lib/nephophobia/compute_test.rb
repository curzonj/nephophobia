require "test_helper"

describe Nephophobia::Compute do
  describe "#all" do
    it "returns all instances" do
      VCR.use_cassette "describe_instances" do
        response = CLIENT.compute.all

        response.size.must_equal 88
      end
    end

    # TODO: Doesn't seem to work.
    #it "returns instances from the given filter" do
    #  VCR.use_cassette "describe_instances_filter_on_instance-type" do
    #    response = CLIENT.compute.all(
    #      "Filter.1.Name"    => "instance-type",
    #      "Filter.1.Value.1" => "m1.small"
    #    )

    #    puts response #response.size.must_equal 88
    #  end
    #end
  end
end
