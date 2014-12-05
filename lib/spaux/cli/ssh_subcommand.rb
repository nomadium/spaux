require 'thor'
require 'chef/http/authenticator'
require 'pry'
require 'tempfile'

class Spaux
  class CLI < Thor
    class SSHSubcommand
      def initialize(*args)
        chef_config = args.shift  || {}
        spaux_config = args.shift || {}

        default_chef_config = Spaux::default_chef_config(:client)
        @config = {}
        @config.merge! default_chef_config.merge(chef_config)

        default_spaux_config = Spaux::default_spaux_config
        @spaux_config = default_spaux_config.merge(spaux_config)

        @config[:raw_key] = Spaux::Chef::Key.new(@spaux_config).raw_key
        redefine_chef_http_authenticator @config[:raw_key]
      end

      def run(nodename, options={})
        begin
          node = ::Chef::Node.load(nodename)
        rescue Net::HTTPServerException => e
          not_found_msg = nodename + ' node could not be found in the server'
          STDERR.puts not_found_msg if e.response.code.eql?('404')
        end
        node_ipaddress = node[:ipaddress]
        node_rsa_public_key = node[:keys][:ssh][:host_rsa_public]
        # write a gem to do this instead of shelling out
        node_key = `ssh-keyscan -H #{node_ipaddress} 2>/dev/null`
        tmp_known_hosts_file = Tempfile.new('tmp_known_hosts_file')
        tmp_known_hosts_file.write(node_key)
        tmp_known_hosts_file.flush
        ssh_cmd = "ssh -o UserKnownHostsFile="
        exec(ssh_cmd + "#{tmp_known_hosts_file.path} #{node_ipaddress}")
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
