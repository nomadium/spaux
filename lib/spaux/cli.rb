require 'thor'
require 'spaux'
require 'spaux/cli/ssh_subcommand'
require 'tmpdir'
require 'fileutils'

class Spaux
  class CLI < Thor
    desc 'converge', 'Run spaux chef client'
    option :dir, :desc => 'Working directory', :banner => 'DIRECTORY'
    option :current, :type => :boolean, :default => true,
      :desc => 'Create and/or use a working directory in the current directory'
    def converge
      work_dir = get_work_dir(options)
      FileUtils.mkdir_p work_dir

      client = Spaux::Chef::Client.new(work_dir)
      client.run
    end
    desc 'savekey', 'Show/save private chef key'
    option :file, :type => :string
    def savekey
      key = Spaux::Chef::RawKey
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
    desc 'ssh', 'Connect via ssh to a node'
    def ssh(nodename)
      ssh_cmd = Spaux::CLI::SSHSubcommand.new
      ssh_cmd.run(nodename, options)
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
  end
end
