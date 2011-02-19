module Nephophobia
  class Compute
    def initialize base
      @base = base
    end

    def describe_instances params = {}
      @base.action "get", "DescribeInstances", params
    end
  end
end
