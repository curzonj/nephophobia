module Nephophobia
  module Response
    class Project
      attr_reader :name, :manager_id, :description

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @name        = attributes['projectname']
        @manager_id  = attributes['projectManagerId']
        @description = attributes['description']
        @member      = attributes['member']
      end
    end
  end
end
