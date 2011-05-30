module Nephophobia
  module Response
    class Return
      attr_reader :return, :request_id

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @request_id = attributes["requestId"]
        @return     = attributes["return"] == "true"
      end
    end
  end
end
