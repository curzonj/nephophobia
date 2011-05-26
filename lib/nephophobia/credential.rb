module Nephophobia
  class CredentialData
    attr_reader :fingerprint, :material, :name

    attr_accessor :attributes

    def initialize attributes
      @attributes = attributes

      @material    = attributes['keyMaterial']
      @name        = attributes['keyName']
      @fingerprint = attributes['keyFingerprint']
    end
  end

  class Credential
    def initialize client
      @client = client
    end

    ##
    # Returns information about key pairs that +@client+ owns.

    def all
      response = @client.action "DescribeKeyPairs", {}

      key_set = response.body['DescribeKeyPairsResponse']['keySet']
      key_set && Nephophobia.coerce(key_set['item']).collect do |data|
        CredentialData.new data
      end
    end

    ##
    # Create a key pair with the given 'key_name'.
    # Returns information about the new key.
    #
    # +key_name+: A String containing a unique name for the key pair.

    def create key_name
      params = {
        "KeyName" => key_name
      }

      response = @client.action "CreateKeyPair", params

      CredentialData.new response.body['CreateKeyPairResponse']
    end

    ##
    # Deletes the key pair for the given 'key_name'.
    # Returns a response to the state change.
    #
    # +key_name+: A String containing a unique name for the key pair.

    def destroy key_name
      params = {
        "KeyName" => key_name
      }

      response = @client.action "DeleteKeyPair", params

      ResponseData.new response.body['DeleteKeyPairResponse']
    end

    ##
    # Returns the credentials for a given 'user_name' for the specified 'project_name'.
    #
    # +user_name+: A String containing a nova user_name.
    # +project_name+: A String containing a nova project_name name.
    #
    # TODO: Determine why it fails in Nova when a user is in more than one project.

    def download user_name, project_name
      params = {
        "Name"    => user_name,
        "Project" => project_name
      }

      response = @client.action "GenerateX509ForUser", params
      Base64.decode64 response.body['GenerateX509ForUserResponse']['file']
    end
  end
end
