module Nephophobia
  module Response
    class Credential
      attr_reader :fingerprint, :material, :name

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @material    = attributes['keyMaterial']
        @name        = attributes['keyName']
        @fingerprint = attributes['keyFingerprint']
      end
    end
  end
end
