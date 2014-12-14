require 'chef/application/knife'
require 'fileutils'
require 'spaux/chef/monkey_patches/knife'

class Spaux
  class Chef
    class Knife < ::Chef::Application::Knife

      attr_accessor :work_dir
      attr_accessor :args

      def initialize(work_dir, args)
        @work_dir = work_dir
        @args = args
        @extra_options = {}
        @extra_options[:config_file] = ::File.join(@work_dir, 'knife.rb')

        raw_key = Spaux::Chef::Key.new.raw_key
        redefine_chef_http_authenticator raw_key

        # to avoid warnings about missing configuration
        @args << '--config' << '/dev/null'
        FileUtils.touch @extra_options[:config_file]
      end

      def run
        Mixlib::Log::Formatter.show_time = false
        quiet_traps
        # I'm not sure why I have to do this if this class is child
        # of Chef::Application::Knife, so options should be set already
        knife = ::Chef::Application::Knife.new
        options = knife.options
        begin
          ::Chef::Knife.run(@args, options, @extra_options)
        rescue SystemExit => e
          # just ignore the exit of knife tool
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
