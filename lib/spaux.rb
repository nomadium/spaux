require 'spaux/version'
require 'spaux/cli'
require 'spaux/chef/client'
require 'spaux/chef/knife'

class Spaux
  def self.default_config_dir
    lib_dir = ::File.expand_path(::File::join(__FILE__, '..'))
    spaux_dir = ::File::join(lib_dir, 'spaux')
  end

  def self.default_config(component)
    filename = case component
    when :client
      'default_client.rb'
    when :knife
      'default_knife.rb'
    else
      raise 'Unknown component'
    end

    config_file = ::File.join(default_config_dir, filename)
    ::Chef::Config.from_string(::File.read(config_file), config_file)
    ::Chef::Config.configuration
  end
end
