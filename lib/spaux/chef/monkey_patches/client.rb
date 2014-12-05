require 'chef'
require 'chef/application/client'

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
