require 'spaux/version'
require 'spaux/cli'
require 'spaux/chef/client'
require 'spaux/chef/knife'

class Spaux
  def self.default_chef_config_dir
    lib_dir = ::File.expand_path(::File::join(__FILE__, '..'))
    chef_conf_dir = ::File::join(lib_dir, 'spaux', 'chef', 'default')
  end

  def self.default_chef_config(component)
    filename = case component
    when :client
      'client.rb'
    when :knife
      'knife.rb'
    else
      raise 'Unknown component'
    end

    config_file = ::File.join(default_chef_config_dir, filename)
    ::Chef::Config.from_string(::File.read(config_file), config_file)
    ::Chef::Config.configuration
  end
end
