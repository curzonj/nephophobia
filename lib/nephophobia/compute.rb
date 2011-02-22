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

    def all params = {}
      response = @client.action "get", "DescribeInstances", params

      response.body.xpath("//xmlns:item")
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

      response = @client.action "get", "TerminateInstances", filter

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

      response = @client.action "get", "DescribeInstances", filter

      response.body
    end
  end
end
