require 'octokit'
require 'net/ssh'
require 'yaml'
require 'rbnacl'

class Spaux
  class Chef
    class Key
      attr_accessor :work_dir
      attr_accessor :raw_key
      attr_accessor :config

      def initialize(config={})
        @work_dir = ::File.join(ENV['PWD'], 'current')
        @config = default_spaux_config.merge(config)
        @raw_key ||= get_raw_key
      end

      private
      # this is wrong, this should in Spaux class
      def default_spaux_config
        spaux_dir = ::File.expand_path(::File::join(__FILE__, '..', '..'))
        config_file = ::File.join(spaux_dir, 'config.rb')
        configuration = eval(::File.read(config_file))
      end
      def get_raw_key
        msg_filename = 'message.yml'
        msg_file = ::File.join(@work_dir, msg_filename)

        if !::File.exists?(msg_file)
          msg = retrieve_msg_from_gist(@config[:chef_private_key_gist_id])
          begin
            ::IO.write(msg_file, msg)
          rescue Exception => e
            puts e.message
          end
        else
          msg = ::IO.read(msg_file)
        end

        message = YAML.safe_load(msg)
        key = decrypt_message(message, @config[:private_key])
      end

      def retrieve_msg_from_gist(gist_id)
        client = Octokit::Client.new
        gist = client.gist(gist_id)
        filename = gist[:files].fields.first
        resource = gist[:files][filename]
        data = resource[:content]
      end

      def decrypt_message(message, rsa_key_filename)
        rsa_key = Net::SSH::KeyFactory.load_private_key(rsa_key_filename)
        recipients = message['recipients']
        box_key = nil

        recipients.each do |r|
          begin
            box_key = rsa_key.private_decrypt(Base64.decode64(r))
          rescue OpenSSL::PKey::RSAError => e
            next if e.message.eql?('padding check failed')
          end
        end

        raise ArgumentError, 'Unable to decrypt message!' if box_key.nil?

        box = ::RbNaCl::SimpleBox.from_secret_key(box_key)
        clear_message = box.decrypt(Base64.decode64(message['data']))
      end
    end
  end
end
