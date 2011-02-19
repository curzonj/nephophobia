module Nephophobia
  class Compute
    def initialize base
      @base = base
    end

    def describe_instances params = {}
      @base.action "get", { "Action" => "DescribeInstances" }.merge(params)
    end
  end
end
