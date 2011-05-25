module Nephophobia
  class ComputeData
    attr_reader :description, :dns_name, :image_id, :instance_id, :instance_type
    attr_reader :key_name, :launch_time, :name, :owner_id, :placement
    attr_reader :private_dns_name, :project_id, :public_dns_name, :state

    attr_accessor :attributes

    def initialize attributes
      @attributes = attributes

      @project_id       = attributes['ownerId']
      item              = attributes['instancesSet']['item']
      item              = item.first if item.is_a?(Array)
      @description      = item['displayDescription']
      @name             = item['displayName']
      @key_name         = item['keyName']
      @instance_id      = item['instanceId']
      @state            = item['instanceState']['name']
      @public_dns_name  = item['publicDnsName']
      @private_dns_name = item['privateDnsName']
      @image_id         = item['imageId']
      @dns_name         = item['dnsName']
      @launch_time      = DateTime.parse(item['launchTime'])
      @placement        = item['placement']['availabilityZone']
      @instance_type    = item['instanceType']
    end
  end

  class VncData
    attr_reader :url, :attributes

    def initialize attributes
      @url = attributes['url']
    end
  end

  class Compute
    def initialize client
      @client = client
    end

    ##
    # Returns information about instances that +@client+ owns.
    #
    # +filter+: An optional Hash, intended for filtering.
    #           See the API Reference for further details.
    #           {
    #             "Filter.1.Name"    => "instance-type",
    #             "Filter.1.Value.1" => "m1.small"
    #           }

    def all filter = {}
      response = @client.action "DescribeInstances", filter

      item = response.body['DescribeInstancesResponse']['reservationSet']['item']
      Nephophobia.coerce(item).collect do |data|
        ComputeData.new data
      end
    end

    ##
    # Create a compute instance with the given 'image_id'.
    # Returns information about the new instance.
    #
    # +image_id+: A String representing the ID of the image.
    # +params+: An optional Hash.
    #           See the API Reference for further details.
    #           {
    #             "DisplayName"        => "testserver1",
    #             "DisplayDescription" => "test description"
    #           }

    def create image_id, params = {}
      response = @client.action "RunInstances", { "ImageId" => image_id }.merge(params)

      ComputeData.new response.body['RunInstancesResponse']
    end

    ##
    # Removes the given 'instance_id'.
    # Returns instances response to a state change.
    #
    # +instance_id+: A String representing the ID of the instance.

    def destroy instance_id
      params = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "TerminateInstances", params

      ResponseData.new response.body['TerminateInstancesResponse']
    end

    ##
    # Returns information about the given 'instance_id'.
    #
    # +instance_id+: A String representing the ID of the instance.

    def find instance_id
      params = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "DescribeInstances", params

      ComputeData.new response.body['DescribeInstancesResponse']['reservationSet']['item']
    end

    ##
    # Reboot the given 'instance_id'.
    # Returns instances response to a state change.
    #
    # +instance_id+: A String representing the ID of the instance.

    def reboot instance_id
      params = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "RebootInstances", params

      ResponseData.new response.body['RebootInstancesResponse']
    end

    ##
    # Starts the given 'instance_id'.
    # Returns instances current and previous state.
    #
    # +instance_id+: A String representing the ID of the instance.

    def start instance_id
      params = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "StopInstances", params

      ResponseData.new response.body
    end

    ##
    # Stops the given 'instance_id'
    # Returns instances current and previous state.
    #
    # +instance_id+: A String representing the ID of the instance.

    def stop instance_id
      params = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "StartInstances", params

      ResponseData.new response.body
    end

    ##
    # Returns the VNC browser URL.  Used by the Portal.
    # __Must__ execute as a user with the +admin+ role.
    #
    # +instance_id+: A String representing the ID of the instance.

    def vnc_url instance_id
      params = {
        "InstanceId" => instance_id
      }

      response = @client.action "GetVncConsole", params

      VncData.new response.body['GetVncConsoleResponse']
    end

    def allocate_address
      response = @client.action "AllocateAddress", {}
      ResponseData.new response.body["AllocateAddressResponse"]
    end

    def release_address floating_ip
      params = {
        "PublicIp" => floating_ip
      }
      response = @client.action "ReleaseAddress", params
      ResponseData.new response.body["ReleaseAddressResponse"]
    end

    def associate_address instance_id, floating_ip
      params = {
        "InstanceId" => instance_id,
        "PublicIp" => floating_ip
      }
      response = @client.action "AssociateAddress", params
      ResponseData.new response.body["AssociateAddressResponse"]
    end

    def disassociate_address floating_ip
      params = {
        "PublicIp" => floating_ip
      }
      response = @client.action "DisassociateAddress", params
      ResponseData.new response.body["DisassociateAddressResponse"]
    end

  end
end
