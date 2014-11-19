require 'spaux/version'
require 'spaux/cli'
require 'spaux/chef/client'
require 'spaux/chef/knife'

class Spaux
  def self.default_knife_config
    lib_dir = ::File.expand_path(::File::join(__FILE__, '..'))
    knife_rb = ::File::join(lib_dir, 'spaux', 'defaults', 'knife.rb')
    ::Chef::Config.from_string(::File.read(knife_rb), knife_rb)
    ::Chef::Config.configuration
  end
end
