module Nephophobia
  module Response
    class Member
      attr_reader :member

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @member = attributes['member']
      end
    end
  end
end
