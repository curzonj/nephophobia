require "test_helper"

describe Nephophobia::Compute do
  before { @compute = Nephophobia::Compute.new USER_CLIENT }

  describe "#all" do
    it "returns all instances" do
      VCR.use_cassette "compute_all" do
        response = @compute.all

        response.size.must_equal 2
      end
    end

    it "API doesn't implement Filter" do
      VCR.use_cassette "compute_all_with_filter" do
        filter = {
          "Filter.1.Name"    => "instance-type",
          "Filter.1.Value.1" => "m1.small"
        }

        lambda { @compute.all filter }.must_raise Hugs::Errors::BadRequest
      end
    end
  end

  describe "#create" do
    before { @image_id = "ami-usc3oydl" }

    it "create an instance with given 'image_id'" do
      VCR.use_cassette "compute_create" do
        response = @compute.create @image_id

        response['imageId'].must_equal @image_id
      end
    end
  end

  describe "#destroy" do
    before { @instance_id = "i-000000c7" }

    it "destroy the given 'instance_id'" do
      VCR.use_cassette "compute_destroy" do
        response = @compute.destroy @instance_id

        response['return'].must_equal "true"
      end
    end
  end

  describe "#find" do
    before { @instance_id = "i-000000c7" }

    it "returns the given 'instance_id'" do
      VCR.use_cassette "compute_find" do
        response = @compute.find @instance_id

        response['instancesSet']['item']['instanceId'].must_equal @instance_id
      end
    end
  end

  describe "#reboot" do
    before { @instance_id = "i-00000471" }

    it "reboots the given 'instance_id'" do
      VCR.use_cassette "compute_reboot" do
        response = @compute.reboot @instance_id

        response['return'].must_equal "true"
      end
    end
  end

  describe "#start" do
    before { @instance_id = "i-00000471" }

    # 2011-02-26 22:24:55,809 ERROR nova.api [HU844ZYTDM1-8QJIY6MI jdewey production] Unexpected error raised: Unsupported API request: controller = CloudController, action = StartInstances
    it "API doesn't implement StartInstances" do
      VCR.use_cassette "compute_start" do
        lambda { @compute.start @instance_id }.must_raise Hugs::Errors::BadRequest
      end
    end
  end

  describe "#stop" do
    before { @instance_id = "i-00000471" }

    # 2011-02-26 20:50:45,375 ERROR nova.api [HIA363E2X4025I-FIZ7E jdewey production] Unexpected error raised: Unsupported API request: controller = CloudController, action = StopInstances
    it "API doesn't implement StopInstances" do
      VCR.use_cassette "compute_stop" do
        lambda { @compute.stop @instance_id }.must_raise Hugs::Errors::BadRequest
      end
    end
  end
end
