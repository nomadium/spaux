require 'chef/application/knife'
require 'fileutils'
require 'spaux/chef/monkey_patches/knife'

class Spaux
  class Chef
    class Knife < ::Chef::Application::Knife

      DEFAULT_KNIFE_CONFIG = {
        config_file: {
          flags: %w(--config -c),
          value: ::File.join('@work_dir', 'knife.rb')
        }
      }

      attr_accessor :work_dir
      attr_accessor :args

      def initialize(work_dir, args)
        @work_dir = work_dir
        @args = args

        DEFAULT_KNIFE_CONFIG.each do |_,v|
          v[:value].is_a?(String) && v[:value].gsub!(/@work_dir/, @work_dir)
        end

        cf_flags = DEFAULT_KNIFE_CONFIG[:config_file][:flags]
        unless @args.include?(cf_flags.first) || @args.include?(cf_flags.last)
          @args << DEFAULT_KNIFE_CONFIG[:config_file][:flags].first
          @args << DEFAULT_KNIFE_CONFIG[:config_file][:value]
        end

        config_file = DEFAULT_KNIFE_CONFIG[:config_file][:value]
        FileUtils.touch config_file
      end

      def run
        Mixlib::Log::Formatter.show_time = false
        quiet_traps
        # I'm not sure why I have to do this if this class is child
        # of Chef::Application::Knife, so options should be set already
        knife = ::Chef::Application::Knife.new
        options = knife.options
        begin
          ::Chef::Knife.run(@args, options)
        rescue SystemExit => e
          # just ignore the exit of knife tool
        end
      end
    end
  end
end
