module Nephophobia
  module Response
    class Address
      attr_reader :attributes, :floating_ip, :status, :instance_id

      def initialize attributes
        @floating_ip = attributes['publicIp']
        @instance_id = attributes['instanceId']
        @status      = attributes['item']
      end
    end
  end
end
