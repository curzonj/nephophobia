module Nephophobia
  class Compute
    def initialize base
      @base = base
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


    def all params = {}
      response = @base.action "get", "DescribeInstances", params

      response.body.xpath('//xmlns:item')
    end


    ##
    # Returns information about the specified instance.
    #
    # +instance_id+: A String representing the ID of the instance.

    def find instance_id
      filter = {
        "InstanceId.1" => instance_id
      }

      response = @base.action "get", "DescribeInstances", filter

      response.body
    end
  end
end
