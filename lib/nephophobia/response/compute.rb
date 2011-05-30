module Nephophobia
  module Response
    class Compute
      attr_reader :description, :dns_name, :image_id, :instance_id, :instance_type
      attr_reader :key_name, :launch_time, :name, :owner_id, :placement
      attr_reader :private_dns_name, :project_id, :public_dns_name, :state

      attr_accessor :attributes

      def initialize attributes
        @attributes = attributes

        @project_id       = attributes['ownerId']
        item              = attributes['instancesSet']['item']
        item              = item.first if item.is_a?(Array)
        @description      = item['displayDescription']
        @name             = item['displayName']
        @key_name         = item['keyName']
        @instance_id      = item['instanceId']
        @state            = item['instanceState']['name']
        @public_dns_name  = item['publicDnsName']
        @private_dns_name = item['privateDnsName']
        @image_id         = item['imageId']
        @dns_name         = item['dnsName']
        @launch_time      = DateTime.parse(item['launchTime'])
        @placement        = item['placement']['availabilityZone']
        @instance_type    = item['instanceType']
      end
    end
  end
end
