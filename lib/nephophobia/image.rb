##
# TODO:
#   - Filters do not appear to work.
#   - #all should return images +@client+ has access to run.
#     Appears to return everything.

module Nephophobia
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

    def all params = {}
      response = @client.action "get", "DescribeImages", params

      response.body.xpath("//xmlns:item")
    end

    ##
    # Returns information about the specified image.
    #
    # +image_id+: A String representing the ID of the image.

    def find image_id
      filter = {
        "ImageId.1" => image_id
      }

      response = @client.action "get", "DescribeImages", filter

      response.body
    end
  end
end
