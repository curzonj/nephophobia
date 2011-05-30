require "test_helper"

describe Nephophobia::Resource::Compute do
  ##
  # Note:
  #   Assumes there is always at least one valid project.
  #   Projects are core functionality to nova networking.
  #   We will always have at least one project configured.

  before do
    @project_name = "sandbox"
    @image_id     = "ami-00000002"
    @compute      = ::Client.with(:user).compute
  end

  describe "#all" do
    before do
      VCR.use_cassette "compute_all" do
        @instance_id = @compute.create(@image_id).instance_id

        @response = @compute.all
      end
    end

    after do
      VCR.use_cassette "compute_all" do
        @compute.destroy @instance_id
      end
    end

    it "returns all instances" do
      @response.size.must_be :>=, 1
    end
  end

  describe "#all with filter" do
    before do
      VCR.use_cassette "compute_all_with_filter" do
        @instance_id = @compute.create(@image_id).instance_id
      end
    end

    after do
      VCR.use_cassette "compute_all_with_filter" do
        @compute.destroy @instance_id
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
    it "create an instance with given 'image_id'" do
      VCR.use_cassette "compute_create" do
        response    = @compute.create @image_id
        instance_id = response.instance_id

        @compute.destroy instance_id

        response.image_id.must_equal @image_id
      end
    end

    it "create an instance with optional params" do
      params = {
        "DisplayName"        => "testserver1",
        "DisplayDescription" => "test description"
      }

      VCR.use_cassette "compute_create_with_optional_params" do
        response    = @compute.create @image_id, params
        instance_id = response.instance_id

        @compute.destroy instance_id

        response.name.must_equal "testserver1"
        response.description.must_equal "test description"
      end
    end
  end

  describe "#destroy" do
    before do
      VCR.use_cassette "compute_destroy" do
        instance_id = @compute.create(@image_id).instance_id

        @response = @compute.destroy instance_id
      end
    end

    it "destroy the given 'instance_id'" do
      @response.return.must_equal true
    end
  end

  describe "#find" do
    before do
      VCR.use_cassette "compute_find" do
        @instance_id = @compute.create(@image_id).instance_id

        @response = @compute.find @instance_id
      end
    end

    after do
      VCR.use_cassette "compute_find" do
        @compute.destroy @instance_id
      end
    end

    it "returns the given 'instance_id'" do
      @response.instance_id.must_equal @instance_id
    end

    it "contains the compute data" do
      @response.project_id.must_equal @project_name
      @response.description.must_be_nil
      @response.name.must_match %r{Server [0-9]+}
      @response.respond_to?(:key_name).must_equal true
      @response.instance_id.must_match %r{i-[a-z0-9]+}
      @response.state.must_match %r{[a-z]+}
      @response.respond_to?(:dns_name).must_equal true
      @response.respond_to?(:public_dns_name).must_equal true
      @response.respond_to?(:private_dns_name).must_equal true
      @response.image_id.must_match %r{ami-[a-z0-9]+}
      @response.launch_time.must_be_kind_of DateTime
      @response.placement.must_match %r{[a-z]+}
      @response.instance_type.must_match %r{[a-z]{2}.[a-z]+}
    end
  end

  describe "#reboot" do
    before do
      VCR.use_cassette "compute_reboot" do
        @instance_id = @compute.create(@image_id).instance_id

        @response = @compute.reboot @instance_id
      end
    end

    after do
      VCR.use_cassette "compute_reboot" do
        @compute.destroy @instance_id
      end
    end

    it "reboots the given 'instance_id'" do
      @response.return.must_equal true
    end
  end
  describe "#vnc_url" do
    before do
      VCR.use_cassette "compute_vnc_url" do
        @compute = ::Client.trunk_with(:admin).compute

        @instance_id = @compute.create(@image_id).instance_id

        @response = @compute.vnc_url @instance_id
      end
    end

    after do
      VCR.use_cassette "compute_vnc_url" do
        @compute.destroy @instance_id
      end
    end

    it "has a vnc url for the given 'instance_id'" do
      @response.url.must_match %r{/vnc_auto.html\?token=[a-z0-9-]+}
    end
  end

  describe "#allocate_address" do
    before do
      VCR.use_cassette "compute_allocate_address" do
        @compute = ::Client.trunk_with(:admin).compute

        @response = @compute.allocate_address
      end
    end

    after do
      VCR.use_cassette "compute_allocate_address" do
        @compute.release_address @response.floating_ip
      end
    end

    it "allocates address" do
      @response.floating_ip.must_match %r{[0-9]{1,3}+\.[0-9]{1,3}}
    end
  end

  describe "not available" do
    describe "#allocate_address" do
      before do
        @compute = ::Client.trunk_with(:admin).compute
      end

      it "has no available address" do
        VCR.use_cassette "compute_allocate_address_when_not_available" do
          lambda { @compute.allocate_address}.must_raise Hugs::Errors::BadRequest
        end
      end
    end
  end

  describe "#release_address" do
    before do
      VCR.use_cassette "compute_release_address" do
        @compute = ::Client.trunk_with(:admin).compute

        floating_ip = @compute.allocate_address.floating_ip
        @response   = @compute.release_address floating_ip
      end
    end

    it "released the floating ip" do
      @response.status.must_equal "Address released."
    end
  end

  describe "#associate_address" do
    before do
      VCR.use_cassette "compute_associate_address" do
        @compute = ::Client.trunk_with(:admin).compute

        @floating_ip = @compute.allocate_address.floating_ip
        @instance_id = @compute.create(@image_id).instance_id

        sleep 5 unless VCR.current_cassette.record_mode == :none

        @response = @compute.associate_address @instance_id, @floating_ip
      end
    end

    after do
      VCR.use_cassette "compute_associate_address" do
        @compute.destroy @instance_id
        @compute.release_address @floating_ip
      end
    end

    it "has associated the address" do
      @response.status.must_equal "Address associated."
    end
  end

  describe "#disassociate_address" do
    before do
      VCR.use_cassette "compute_disassociate_address" do
        @compute = ::Client.trunk_with(:admin).compute

        @floating_ip = @compute.allocate_address.floating_ip
        @instance_id = @compute.create(@image_id).instance_id

        sleep 5 unless VCR.current_cassette.record_mode == :none
        @compute.associate_address @instance_id, @floating_ip

        sleep 5 unless VCR.current_cassette.record_mode == :none
        @response = @compute.disassociate_address @floating_ip
      end
    end

    after do
      VCR.use_cassette "compute_disassociate_address" do
        @compute.destroy @instance_id
        @compute.release_address @floating_ip
      end
    end

    it "remove the floating from instance" do
      @response.status.must_equal "Address disassociated."
    end
  end
end
