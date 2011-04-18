module Nephophobia
  class ComputeData
    attr_reader :description, :dns_name, :image_id, :instance_id, :instance_type
    attr_reader :key_name, :launch_time, :name, :owner_id, :placement
    attr_reader :private_dns_name, :project_id, :public_dns_name, :state

    def initialize hash
      @project_id       = hash['ownerId']
      item              = hash['instancesSet']['item']
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
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "TerminateInstances", filter

      ResponseData.new response.body['TerminateInstancesResponse']
    end

    ##
    # Returns information about the given 'instance_id'.
    #
    # +instance_id+: A String representing the ID of the instance.

    def find instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "DescribeInstances", filter

      ComputeData.new response.body['DescribeInstancesResponse']['reservationSet']['item']
    end

    ##
    # Reboot the given 'instance_id'.
    # Returns instances response to a state change.
    #
    # +instance_id+: A String representing the ID of the instance.

    def reboot instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "RebootInstances", filter

      ResponseData.new response.body['RebootInstancesResponse']
    end

    ##
    # Starts the given 'instance_id'.
    # Returns instances current and previous state.
    #
    # +instance_id+: A String representing the ID of the instance.

    def start instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "StopInstances", filter

      ResponseData.new response.body
    end

    ##
    # Stops the given 'instance_id'
    # Returns instances current and previous state.
    #
    # +instance_id+: A String representing the ID of the instance.

    def stop instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "StartInstances", filter

      ResponseData.new response.body
    end
  end
end
