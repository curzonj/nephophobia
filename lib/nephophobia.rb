require "aws"
require "hashify"
require "nephophobia/client"
require "nephophobia/compute"
require "nephophobia/image"
require "nephophobia/project"
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
end
