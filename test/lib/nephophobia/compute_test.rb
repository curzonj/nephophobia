require "test_helper"

describe Nephophobia::Compute do
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
        ##
        # Pointing to the nova trunk version.

        @compute = ::Client.with(:admin,
          :access_key => "2ea76797-229c-4e52-a21b-f30513cb91a6",
          :secret_key => "3d16b391-820f-4f5c-893b-0f65d5f35312",
          :host       => "10.3.170.35",
          :project    => "sandbox"
        ).compute

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

  describe "#allocate_address_available" do
    before do
      VCR.use_cassette "compute_allocate_address" do
        @compute = ::Client.with(:admin,
          :access_key => "2ea76797-229c-4e52-a21b-f30513cb91a6",
          :secret_key => "3d16b391-820f-4f5c-893b-0f65d5f35312",
          :host       => "10.3.170.35",
          :project    => "sandbox"
        ).compute

        @response = @compute.allocate_address
      end
    end

    after do
      pubip = @response.attributes['publicIp']
      VCR.use_cassette "compute_allocate_address" do
        @compute.release_address pubip
      end
    end

    it 'allocates address' do
      @response.attributes['publicIp'].must_be_kind_of String
    end
  end

  describe "#allocate_address_not_available" do
    before do
      VCR.use_cassette "compute_allocate_address_fail" do
        @compute = ::Client.with(:admin,
          :access_key => "2ea76797-229c-4e52-a21b-f30513cb91a6",
          :secret_key => "3d16b391-820f-4f5c-893b-0f65d5f35312",
          :host       => "10.3.170.35",
          :project    => "sandbox"
        ).compute
      end
    end

    it 'has no available address' do
      VCR.use_cassette "compute_allocate_address_fail" do
        lambda { @compute.allocate_address}.must_raise Hugs::Errors::BadRequest
      end
    end
  end

  describe "#release_address" do
    before do
      VCR.use_cassette "compute_release_address" do
        @compute = ::Client.with(:admin,
          :access_key => "2ea76797-229c-4e52-a21b-f30513cb91a6",
          :secret_key => "3d16b391-820f-4f5c-893b-0f65d5f35312",
          :host       => "10.3.170.35",
          :project    => "sandbox"
        ).compute

        pubip = @compute.allocate_address.attributes['publicIp']
        @response = @compute.release_address pubip
      end
    end

    it 'had removed the floating ip' do
      @response.attributes["releaseResponse"]["item"].must_equal "Address released."
    end
  end

  describe '#associate_address' do
    before do
      VCR.use_cassette "compute_associate_address" do
        @compute = ::Client.with(:admin,
          :access_key => "2ea76797-229c-4e52-a21b-f30513cb91a6",
          :secret_key => "3d16b391-820f-4f5c-893b-0f65d5f35312",
          :host       => "10.3.170.35",
          :project    => "sandbox"
        ).compute
        @pubip = @compute.allocate_address.attributes['publicIp']
        @instance_id = @compute.create(@image_id).instance_id
        # when vcr recording, vm create takes some time to assign fixed ip to come up
        sleep 5 unless VCR.current_cassette.record_mode == :none
        @response = @compute.associate_address(@instance_id, @pubip)
      end
    end

    after do
      VCR.use_cassette "compute_associate_address" do
        @compute.destroy @instance_id
        @compute.release_address @pubip
      end
    end

    it 'has associated the address' do
      @response.attributes["associateResponse"]["item"].must_equal 'Address associated.'
    end
  end

  describe '#disassociate_address' do
    before do
      VCR.use_cassette "compute_disassociate_address" do
        @compute = ::Client.with(:admin,
          :access_key => "2ea76797-229c-4e52-a21b-f30513cb91a6",
          :secret_key => "3d16b391-820f-4f5c-893b-0f65d5f35312",
          :host       => "10.3.170.35",
          :project    => "sandbox"
        ).compute
        @pubip = @compute.allocate_address.attributes['publicIp']
        @instance_id = @compute.create(@image_id).instance_id
        # when vcr recording, vm create takes some time to assign fixed ip to come up
        sleep 5 unless VCR.current_cassette.record_mode == :none
        @compute.associate_address(@instance_id, @pubip)
        sleep 5 unless VCR.current_cassette.record_mode == :none
        @response = @compute.disassociate_address @pubip
      end
    end

    after do
      VCR.use_cassette "compute_disassociate_address" do
        @compute.destroy @instance_id
        @compute.release_address @pubip
      end
    end

    it 'remove the floating from instance' do
      @response.attributes["disassociateResponse"]["item"].must_equal "Address disassociated."
    end
  end

end
