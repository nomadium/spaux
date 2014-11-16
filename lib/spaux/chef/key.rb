require 'octokit'
require 'net/ssh'

class Spaux
  class Chef
    class Key
      attr_accessor :work_dir
      attr_accessor :raw_key
      attr_accessor :config

      DEFAULT_SPAUX_CONFIG = {
        chef_private_key_gist_id: '16b65a73953427ce9c40',
        private_key:              '~/.ssh/id_rsa',
        aes_key_size:             256,
        aes_cipher_mode:          :CBC
      }

      def initialize(config={})
        @work_dir = ::File.join(ENV['PWD'], 'current')
        @config = config.merge(DEFAULT_SPAUX_CONFIG)
        @raw_key ||= get_raw_key
      end

      private
      def get_raw_key
        key_filename = 'encrypted.rb'
        key_file = ::File.join(@work_dir, key_filename)

        if !::File.exists?(key_file)
          key = retrieve_key_from_gist(@config[:chef_private_key_gist_id])
          begin
            ::File.write(key_file, key)
          rescue Exception => e
            puts e.message
          end
        else
          key = ::File.read(key_file)
        end

        key_hash = eval(key)
        raw_key = decrypt_key(key_hash, @config[:private_key])
      end

      def retrieve_key_from_gist(gist)
        client = Octokit::Client.new
        key_gist = client.gist(gist)
        key_filename = key_gist[:files].fields.first
        key_resource = key_gist[:files][key_filename]
        key_data = key_resource[:content]
      end

      def decrypt_key(key_data, rsa_key_filename)
        rsa_key = Net::SSH::KeyFactory.load_private_key(rsa_key_filename)
        iv = Base64.decode64(key_data[:iv])
        sym_key = Base64.decode64(key_data[:key])
        data = Base64.decode64(key_data[:data])

        decipher = OpenSSL::Cipher::AES.new(@config[:aes_key_size],
                                            @config[:aes_cipher_mode])
        decipher.decrypt
        decipher.iv = rsa_key.private_decrypt(iv)
        decipher.key = rsa_key.private_decrypt(sym_key)
        key = decipher.update(data) + decipher.final
      end
    end
  end
end

Spaux::Chef::RawKey = Spaux::Chef::Key.new.raw_key
