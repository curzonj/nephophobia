require "aws"
require "hashify"
require "date"
require "nephophobia/client"
require "nephophobia/compute"
require "nephophobia/credential"
require "nephophobia/image"
require "nephophobia/project"
require "nephophobia/role"
require "nephophobia/user"

require "hugs"

module Nephophobia
  class ResponseData
    attr_reader :return, :request_id

    def initialize hash
      @request_id = hash["requestId"]
      @return     = hash["return"] == "true"
    end
  end

  ##
  # Wraps a Hash with an Array.
  #
  # +obj+: The Object to be tested for wrapping.

  def self.coerce obj
    (obj.is_a? Hash) ? [obj] : obj
  end
end
