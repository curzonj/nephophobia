module Nephophobia
  class ImageData
    attr_reader :architecture, :image_id, :image_location, :image_owner_id
    attr_reader :image_type, :kernel_id, :is_public, :state

    def initialize hash
      @architecture   = hash['architecture']
      @id             = hash['id']
      @image_id       = hash['imageId']
      @image_location = hash['imageLocation']
      @image_owner_id = hash['imageOwnerId']
      @image_type     = hash['imageType']
      @kernel_id      = hash['kernelId']
      @is_public      = hash['isPublic']
    end
  end

  class Image
    def initialize client
      @client = client
    end

    ##
    # Returns information about AMIs, AKIs, and ARIs. Images returned include
    # public images, private images that +@client+ owns, and private images
    # owned by other AWS accounts but for which +@client+ has explicit launch
    # permissions.
    #
    # +params+: Intended for filtering.
    #           See the API Reference for further details.
    #           {
    #             "Filter.1.Name"    => "instance-type",
    #             "Filter.1.Value.1" => "m1.small",
    #             "ExecutableBy.1"   => "self",
    #           }

    def all filter = {}
      response = @client.action "DescribeImages", filter

      response.body['DescribeImagesResponse']['imagesSet']['item'].collect do |data|
        ImageData.new data
      end
    end

    ##
    # Returns information about the specified 'image_id'.
    #
    # +image_id+: A String representing the ID of the image.

    def find image_id
      filter = {
        "ImageId.1" => image_id
      }

      response = @client.action "DescribeImages", filter

      ImageData.new response.body['DescribeImagesResponse']['imagesSet']['item']
    end

    ##
    # Return information about all public images.

    def public
      all.select do |image|
        public? image
      end
    end

  private
    ##
    # images which do not have a valid kernel_id are not runnable.

    def public? image
      image.is_public == "true" && image.kernel_id != "true"
    end
  end
end
