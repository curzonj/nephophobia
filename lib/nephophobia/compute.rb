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
  end
end
