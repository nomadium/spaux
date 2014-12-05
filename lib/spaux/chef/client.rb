require 'spaux/chef/key'
require 'spaux/chef/monkey_patches/client'

class Spaux
  class Chef
    class Client < ::Chef::Application::Client
      attr_accessor :work_dir
      attr_accessor :spaux_config

      def initialize(work_dir, *args)
        @work_dir = work_dir
        chef_config = args.shift  || {}
        spaux_config = args.shift || {}
        super()

        default_chef_config = Spaux::default_chef_config(:client)

        default_chef_config.each { |_,v| v.is_a?(String) && v.gsub!(/@work_dir/, @work_dir) }
        @config.merge! default_chef_config.merge(chef_config)

        default_spaux_config = Spaux::default_spaux_config
        @spaux_config = default_spaux_config.merge(spaux_config)

        @config[:raw_key] = Spaux::Chef::Key.new(@spaux_config).raw_key
        # ugly hack but better than another options...
        redefine_chef_http_authenticator @config[:raw_key]

        FileUtils.touch @config[:config_file]
        FileUtils.touch @config[:client_key]
        unless chef_config[:json_attribs]
          @config.delete(:json_attribs) if !::File.exists?(@config[:json_attribs])
        end
        ENV['SPAUX_HOME'] = @work_dir
      end

      def reconfigure
        super
        ::Chef::Config[:specific_recipes] = []
      end

      def parse_options(argv=ARGV)
        argv = []
        super
      end

      def run_application
        begin
          super
        rescue SystemExit => e
          # just ignore chef-client exit
        end
      end

      private
      def redefine_chef_http_authenticator(key)
        ::Chef::HTTP::Authenticator.send(:define_method,
          'load_signing_key') do |signing_key_filename, raw_key|
          @raw_key = key
          @key = OpenSSL::PKey::RSA.new(@raw_key)
        end
      end
    end
  end
end
