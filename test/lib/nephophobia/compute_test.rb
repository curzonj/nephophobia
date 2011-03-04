require "test_helper"

describe Nephophobia::Compute do
  before { @compute = Nephophobia::Compute.new USER_CLIENT }

  describe "#compute" do
    it "has compute decorator" do
      USER_CLIENT.must_respond_to :compute
    end
  end

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

    it "has a 'TypeError: can't convert String into Integer' error" do
      VCR.use_cassette "compute_all_with_string_into_int_error" do
        response = @compute.all

        response.size.must_equal 1
      end
    end
  end

  describe "#create" do
    before { @image_id = "ami-usc3oydl" }

    it "create an instance with given 'image_id'" do
      VCR.use_cassette "compute_create" do
        response = @compute.create @image_id

        response.image_id.must_equal @image_id
      end
    end
  end

  describe "#destroy" do
    before { @instance_id = "i-000000c7" }

    it "destroy the given 'instance_id'" do
      VCR.use_cassette "compute_destroy" do
        response = @compute.destroy @instance_id

        response.return.must_equal true
      end
    end
  end

  describe "#find" do
    before do
      @instance_id = "i-000000c7"

      VCR.use_cassette "compute_find" do
        @response = @compute.find @instance_id
      end
    end

    it "returns the given 'instance_id'" do
      @response.instance_id.must_equal @instance_id
    end

    it "contains the compute data" do
      compute = @response

      compute.project_id.must_equal "production"
      compute.description.must_be_nil
      compute.name.must_equal "Server 199"
      compute.key_name.must_equal "None (production, e3ab3)"
      compute.instance_id.must_equal "i-000000c7"
      compute.state.must_equal "running"
      compute.public_dns_name.must_be_nil
      compute.private_dns_name.must_equal "10.1.171.8"
      compute.image_id.must_equal "ami-usc3oydl"
      compute.dns_name.must_equal "10.1.171.8"
      compute.launch_time.must_equal Time.new("2011-02-21 17:54:35").utc
      compute.placement.must_equal "nova"
      compute.instance_type.must_equal "m1.small"
    end
  end

  describe "#reboot" do
    before { @instance_id = "i-00000471" }

    it "reboots the given 'instance_id'" do
      VCR.use_cassette "compute_reboot" do
        response = @compute.reboot @instance_id

        response.return.must_equal true
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
