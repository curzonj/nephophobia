require "aws"
require "hashify"
require "date"
require "nephophobia/client"
require "nephophobia/util"
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
require "nephophobia/resource/compute"
require "nephophobia/resource/credential"
require "nephophobia/resource/image"
require "nephophobia/resource/project"
require "nephophobia/resource/role"
require "nephophobia/resource/user"

require "hugs"

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
