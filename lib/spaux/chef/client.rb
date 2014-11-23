require 'spaux/chef/key'
require 'spaux/chef/monkey_patches'

class Spaux
  class Chef
    class Client < ::Chef::Application::Client
      attr_accessor :work_dir
      attr_accessor :spaux_config

      DEFAULT_CHEF_CONFIG = {
        config_file:      ::File.join('@work_dir', 'client.rb'),
        cache_path:       ::File.join('@work_dir', '.chef'),
        client_key:       ::File.join('@work_dir', 'client.pem'),
        json_attribs:     ::File.join('@work_dir', 'attributes.json'),
        chef_server_url:  'https://api.opscode.com/organizations/spaux',
        ssl_verify_mode:  :verify_peer,
        node_name:        'spaux',
        override_runlist: ["recipe[spaux::machine]"]
      }

      def initialize(work_dir, *args)
        @work_dir = work_dir
        chef_config = args.shift  || {}
        spaux_config = args.shift || {}
        super()

        DEFAULT_CHEF_CONFIG.each { |_,v| v.is_a?(String) && v.gsub!(/@work_dir/, @work_dir) }
        @config.merge! DEFAULT_CHEF_CONFIG.merge(chef_config)

        default_spaux_config = Spaux::Chef::Key::DEFAULT_SPAUX_CONFIG
        @spaux_config = default_spaux_config.merge(spaux_config)
        #if !@spaux_config.eql?(default_spaux_config)
          #trigger a reevalutation of the private key

        @config[:raw_key] = Spaux::Chef::RawKey

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
    end
  end
end
