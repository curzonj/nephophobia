module Nephophobia
  module Resource
    class Credential
      def initialize client
        @client = client
      end

      ##
      # Returns information about key pairs that +@client+ owns.

      def all
        response = @client.action "DescribeKeyPairs", {}

        key_set = response.body['DescribeKeyPairsResponse']['keySet']
        key_set && Nephophobia::Util.coerce(key_set['item']).collect do |data|
          Response::Credential.new data
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

        Response::Credential.new response.body['CreateKeyPairResponse']
      end

      ##
      # Import a key pair

      def import key_name, pubkey, fprint=nil
        params = { 
          'KeyName' => key_name,
          'PublicKey' => pubkey
        }
        params.merge!( 'Fingerprint' => fprint ) unless fprint.nil?

        response = @client.action "ImportPublicKey", params

        Response::Credential.new response.body["ImportPublicKeyResponse"]['return']
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

        Response::Return.new response.body['DeleteKeyPairResponse']
      end
    end
  end
end
