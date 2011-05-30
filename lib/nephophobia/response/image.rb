module Nephophobia
  module Response
    class Image
      attr_reader :architecture, :image_id, :image_location, :image_owner_id
      attr_reader :image_type, :kernel_id, :is_public, :state

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @architecture   = attributes['architecture']
        @id             = attributes['id']
        @image_id       = attributes['imageId']
        @image_location = attributes['imageLocation']
        @image_owner_id = attributes['imageOwnerId']
        @image_type     = attributes['imageType']
        @is_public      = attributes['isPublic']
        @kernel_id      = attributes['kernelId']
        @state          = attributes['imageState']
      end
    end
  end
end
