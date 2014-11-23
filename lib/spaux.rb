require 'spaux/version'
require 'spaux/cli'
require 'spaux/chef/client'
require 'spaux/chef/knife'

class Spaux
  def self.default_config_dir(component)
    lib_dir = ::File.expand_path(::File::join(__FILE__, '..'))
    dir = case component
    when :chef
      chef_conf_dir = ::File::join(lib_dir, 'spaux', 'chef', 'default')
    when :spaux
      spaux_conf_dir = ::File::join(lib_dir, 'spaux')
    end
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

    config_file = ::File.join(default_config_dir(:chef), filename)
    ::Chef::Config.from_string(::File.read(config_file), config_file)
    ::Chef::Config.configuration
  end

  def self.default_spaux_config
    config_dir = default_config_dir(:spaux)
    config_file = ::File.join(config_dir, 'config.rb')
    configuration = eval(::File.read(config_file))
  end
end
