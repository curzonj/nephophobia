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
      @is_public      = hash['isPublic']
      @kernel_id      = hash['kernelId']
      @state          = hash['imageState']
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
    # +filter+: An optional Hash, intended for filtering.
    #           See the API Reference for further details.
    #           {
    #             "Filter.1.Name"    => "instance-type",
    #             "Filter.1.Value.1" => "m1.small",
    #             "ExecutableBy.1"   => "self",
    #           }

    def all filter = {}
      response = @client.action "DescribeImages", filter

      item = response.body['DescribeImagesResponse']['imagesSet']['item'].collect do |data|
        ImageData.new data
      end
    end

    ##
    # Returns information about the given 'image_id'.
    #
    # +image_id+: A String representing the ID of the image.

    def find image_id
      params = {
        "ImageId.1" => image_id
      }

      response = @client.action "DescribeImages", params

      ImageData.new response.body['DescribeImagesResponse']['imagesSet']['item']
    end

    ##
    # Return information about all public images.

    def runnable
      all.select do |image|
        runnable? image
      end
    end

  private
    ##
    # Images which do not have a valid kernel_id are not runnable.

    def runnable? image
      image.is_public == "true" &&
      image.kernel_id != "true" &&
      image.image_type == "machine"
    end
  end
end
