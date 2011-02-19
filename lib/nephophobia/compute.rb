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
    #           { "Filter.1.Name" => "instance-type" }


    def all params = {}
      @base.action "get", "DescribeInstances", params
    end
  end
end
