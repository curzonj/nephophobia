module Nephophobia
  module Response
    class Address
      attr_reader :attributes, :floating_ip, :status

      def initialize attributes
        @floating_ip = attributes['publicIp']
        @status      = attributes['item']
      end
    end
  end
end
