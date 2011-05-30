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
require "nephophobia/response/address"
require "nephophobia/response/compute"
require "nephophobia/response/credential"
require "nephophobia/response/image"
require "nephophobia/response/member"
require "nephophobia/response/project"
require "nephophobia/response/return"
require "nephophobia/response/role"
require "nephophobia/response/user"
require "nephophobia/response/vnc"

require "hugs"

module Nephophobia
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
      ::Nephophobia::Response::Address,
      ::Nephophobia::Response::Compute,
      ::Nephophobia::Response::Credential,
      ::Nephophobia::Response::Image,
      ::Nephophobia::Response::Member,
      ::Nephophobia::Response::Project,
      ::Nephophobia::Response::Role,
      ::Nephophobia::Response::User,
      ::Nephophobia::Response::Vnc
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
