module Nephophobia
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
        Response::Compute.new data
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

      Response::Compute.new response.body['RunInstancesResponse']
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

      Response::Return.new response.body['TerminateInstancesResponse']
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

      Response::Compute.new response.body['DescribeInstancesResponse']['reservationSet']['item']
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

      Response::Return.new response.body['RebootInstancesResponse']
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

      Response::Return.new response.body
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

      Response::Return.new response.body
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

      Response::Vnc.new response.body['GetVncConsoleResponse']
    end

    ##
    # Acquires an elastic IP address.
    # Returns an elastic IP.

    def allocate_address
      response = @client.action "AllocateAddress", {}

      Response::Address.new response.body['AllocateAddressResponse']
    end

    ##
    # Releases an elastic IP address.
    #
    # +floating_ip+: A String representing a floating IP address.

    def release_address floating_ip
      params = {
        "PublicIp" => floating_ip
      }

      response = @client.action "ReleaseAddress", params

      Response::Address.new response.body['ReleaseAddressResponse']['releaseResponse']
    end

    ##
    # Associates an elastic IP address with an instance.
    #
    # +instance_id+: A String representing the ID of the instance.
    # +floating_ip+: A String representing a floating IP address.

    def associate_address instance_id, floating_ip
      params = {
        "InstanceId" => instance_id,
        "PublicIp"   => floating_ip
      }

      response = @client.action "AssociateAddress", params

      Response::Address.new response.body['AssociateAddressResponse']['associateResponse']
    end

    ##
    # Disassociates the specified elastic IP address from the instance
    # to which it is assigned.
    #
    # +instance_id+: A String representing the ID of the instance.
    # +floating_ip+: A String representing a floating IP address.

    def disassociate_address floating_ip
      params = {
        "PublicIp" => floating_ip
      }

      response = @client.action "DisassociateAddress", params

      Response::Address.new response.body['DisassociateAddressResponse']['disassociateResponse']
    end
  end
end
