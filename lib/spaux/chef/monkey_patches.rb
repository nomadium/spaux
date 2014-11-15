require 'chef'
require 'chef/application/client'

class Chef
  class HTTP
    class Authenticator
      def load_signing_key(key_file, raw_key = nil)
        @raw_key = Spaux::Chef::RawKey
        @key = OpenSSL::PKey::RSA.new(@raw_key)
      rescue OpenSSL::PKey::RSAError
        msg = "The file #{key_file} or :raw_key option does not contain a correctly formatted private key.\n"
        msg << "The key file should begin with '-----BEGIN RSA PRIVATE KEY-----' and end with '-----END RSA PRIVATE KEY-----'"
        raise Chef::Exceptions::InvalidPrivateKey, msg
      end
    end
  end
end

class ChefVault
  class Item < Chef::DataBagItem
    def secret
      if @keys.include?(Chef::Config[:node_name])
        private_key = OpenSSL::PKey::RSA.new(Chef::Config[:raw_key])
        private_key.private_decrypt(Base64.decode64(@keys[Chef::Config[:node_name]]))
      else
        raise ChefVault::Exceptions::SecretDecryption,
          "#{data_bag}/#{id} is not encrypted with your public key.  "\
          "Contact an administrator of the vault item to encrypt for you!"
      end
    end
  end
end
