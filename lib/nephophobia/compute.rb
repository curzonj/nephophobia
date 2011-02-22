module Nephophobia
  class Compute
    def initialize client
      @client = client
    end

    ##
    # Returns information about instances that you own.
    #
    # +params+: Intended for filtering.
    #           See the API Reference for further details.
    #           {
    #             "Filter.1.Name"    => "instance-type",
    #             "Filter.1.Value.1" => "m1.small"
    #           }

    def all filter = {}
      response = @client.action "get", "DescribeInstances", filter

      response.body.xpath("//xmlns:item")
    end

    ##
    # Returns instances response to a state change.
    # Terminated instances will remain visible after termination (approximately one hour).
    #
    # +instance_id+: A String representing the ID of the instance.
    # instancesSet

    def destroy instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "get", "TerminateInstances", filter

      response.body
    end

    ##
    # Returns information about the specified instance you own.
    #
    # +instance_id+: A String representing the ID of the instance.

    def find instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @client.action "get", "DescribeInstances", filter

      response.body
    end
  end
end

# create
# startup
# shutdown
# reboot
