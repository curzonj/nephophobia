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

    attr_accessor :attributes

    def initialize attributes
      @attributes = attributes

      @request_id = attributes["requestId"]
      @return     = attributes["return"] == "true"
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

##
# Allow Data Classes to comply with ActiveModel.

module Nephophobia
  class Rails
    CLASSES = [
      ::Nephophobia::ComputeData,
      ::Nephophobia::CredentialData,
      ::Nephophobia::ImageData,
      ::Nephophobia::MemberData,
      ::Nephophobia::ProjectData,
      ::Nephophobia::RoleData,
      ::Nephophobia::UserData
    ].freeze

    def self.insert
      CLASSES.each do |clazz|
        clazz.class_eval do
          include ActiveModel::Serialization
        end
      end
    end
  end
end
