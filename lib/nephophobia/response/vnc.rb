module Nephophobia
  module Response
    class Vnc
      attr_reader :attributes, :url

      def initialize attributes
        @url = attributes['url']
      end
    end
  end
end
