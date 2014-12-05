require 'thor'
require 'spaux'
require 'tmpdir'
require 'fileutils'

class Spaux
  class CLI < Thor
    desc 'converge', 'Run spaux chef client'
    option :dir, :desc => 'Working directory', :banner => 'DIRECTORY'
    option :current, :type => :boolean, :default => true,
      :desc => 'Create and/or use a working directory in the current directory'
    option :config, :desc => 'Configuration file to use with chef-client',
      :aliases => :c
    option :spaux_config, :desc => 'Configuration file to use with spaux',
      :aliases => :s
    def converge
      work_dir = get_work_dir(options)
      FileUtils.mkdir_p work_dir

      begin
        chef_config = parse_config_file(options[:config]) if options[:config]
        spaux_config = parse_config_file(options[:spaux_config]) if options[:spaux_config]
        client = Spaux::Chef::Client.new(work_dir, chef_config, spaux_config)
        client.run
      rescue Errno::ENOENT => e
        ssh_message = 'error: You need to create a ssh keypair'
        STDERR.puts ssh_message if e.message.match(/id_rsa/)
      end
    end
    desc 'savekey', 'Show/save private chef key'
    option :file, :type => :string
    def savekey
      key = Spaux::Chef::Key.new.raw_key
      if !options[:file]
        puts key
      else
        ::File.write(options[:file], key)
      end
    end
    desc 'knife', 'Run Chef knife in Spaux context'
    option :dir, :desc => 'Working directory', :banner => 'DIRECTORY'
    option :current, :type => :boolean, :default => true,
      :desc => 'Create and/or use a working directory in the current directory'
    def knife(*args)
      work_dir = get_work_dir(options)
      knife = Spaux::Chef::Knife.new(work_dir, args)
      knife.run
    end

    private
    def get_work_dir(options)
      dir = options[:dir]
      current = options[:current]
      if !dir
        work_dir = if ENV['SPAUX_HOME']
          ENV['SPAUX_HOME']
        elsif current
          ::File.join(ENV['PWD'], 'current')
        else
          Dir.mktmpdir
        end
      else
        work_dir = dir
      end
    end
    def parse_config_file(file)
      begin
        eval(IO.read(file))
      rescue Errno::ENOENT => e
        puts e.message
        {}
      end
    end
  end
end
