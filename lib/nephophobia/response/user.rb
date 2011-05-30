module Nephophobia
  module Response
    class User
      attr_reader :accesskey, :username, :secretkey

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @accesskey = attributes['accesskey']
        @username  = attributes['username']
        @secretkey = attributes['secretkey']
      end
    end
  end
end
