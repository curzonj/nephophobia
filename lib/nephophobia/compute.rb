##
# TODO:
#   - Filters do not appear to work.

module Nephophobia
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

      response.body.xpath("//xmlns:item")
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

      response.body
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

      response.body
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

      response.body
    end

    ##
    # Reboot the compute instance identified by +instance_id+.
    # Returns instances response to a state change.
    #
    # +instance_id+: A String representing the ID of the instance.

    #def reboot compute_id, project = nil
    #  filter = {
    #    "InstanceId.1" => instance_id
    #  }

    #  response = @client.action "StartInstances", filter

    #  response.body
    #end

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
