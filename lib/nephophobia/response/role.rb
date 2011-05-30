module Nephophobia
  module Response
    class Role
      attr_reader :name

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @name = attributes['role']
      end
    end
  end
end
