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
    def converge
      work_dir = get_work_dir(options)
      FileUtils.mkdir_p work_dir

      begin
        client = Spaux::Chef::Client.new(work_dir)
        client.run
      rescue Errno::ENOENT => e
        message = 'error: You need to create a ssh keypair'
        STDERR.puts message if e.message.match(/id_rsa/)
        abort
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
  end
end
