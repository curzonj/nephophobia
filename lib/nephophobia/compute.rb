##
# TODO:
#   - Filters do not appear to work.

module Nephophobia
  class ComputeData
    attr_reader :project_id, :reservation_id, :description, :name, :key_name, :instance_id, :state, :public_dns_name, :image_id, :private_dns_name, :dns_name, :launch_time, :placement, :instance_type
    def initialize hash
      @project_id       = hash["ownerId"]
      @reservation_id   = hash["reservationId"]
      item              = hash["instancesSet"]["item"]
      @description      = item["displayDescription"]
      @name             = item["displayName"]
      @key_name         = item["keyName"]
      @instance_id      = item["instanceId"]
      @state            = item["instanceState"]["name"]
      @public_dns_name  = item["publicDnsName"]
      @private_dns_name = item["privateDnsName"]
      @image_id         = item["imageId"]
      @dns_name         = item["dnsName"]
      @launch_time      = Time.new(item["launchTime"]).utc
      @placement        = item["placement"]["availabilityZone"]
      @instance_type    = item["instanceType"]
    end
  end

  class Compute
    def initialize client
      @client = client
    end

    ##
    # Returns information about instances that +@client+ owns.
    #
    # +params+: Intended for filtering.
    #           See the API Reference for further details.
    #           {
    #             "Filter.1.Name"    => "instance-type",
    #             "Filter.1.Value.1" => "m1.small"
    #           }

    def all filter = {}
      response = @client.action "DescribeInstances", filter

      response.body['DescribeInstancesResponse']['reservationSet']['item'].collect do |data|
        ComputeData.new data
      end
    end

    ##
    # Create the compute instance identified by +instance_id+.
    # Returns information about the new instance.
    #
    # +image_id+: A String representing the ID of the image.

    def create image_id
      filter = {
        "ImageId" => image_id
      }

      response = @client.action "RunInstances", filter

      response.body['RunInstancesResponse']['instancesSet']['item']
    end

    ##
    # Shuts down the given 'instance_id'. This operation is idempotent; if
    # you terminate an instance more than once, each call will succeed.
    # Returns instances response to a state change.
    #
    # +instance_id+: A String representing the ID of the instance.

    def destroy instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "TerminateInstances", filter

      response.body['TerminateInstancesResponse']
    end

    ##
    # Returns information about the given 'instance_id' +@client+ owns.
    #
    # +instance_id+: A String representing the ID of the instance.

    def find instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "DescribeInstances", filter

      response.body['DescribeInstancesResponse']['reservationSet']['item']
    end

    ##
    # Reboot the compute instance identified by +instance_id+.
    # Returns instances response to a state change.
    #
    # +instance_id+: A String representing the ID of the instance.

    def reboot instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "RebootInstances", filter

      response.body['RebootInstancesResponse']
    end

    ##
    # Starts the compute instance identified by +instance_id+.
    # Returns instances current and previous state.
    #
    # +instance_id+: A String representing the ID of the instance.

    def start instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "StopInstances", filter

      response.body
    end

    ##
    # Stops the compute instance identified by +instance_id+.
    # Returns instances current and previous state.
    #
    # +instance_id+: A String representing the ID of the instance.

    def stop instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "StartInstances", filter

      response.body
    end
  end
end
