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
      work_dir = options[:dir]
      if not work_dir
        if ENV['SPAUX_HOME']
          work_dir = ENV['SPAUX_HOME']
        elsif options[:current]
          work_dir = ::File.join(ENV['PWD'], 'current')
        else
          work_dir = Dir.mktmpdir
        end
      end
      FileUtils.mkdir_p work_dir

      client = Spaux::Chef::Client.new(work_dir)
      client.run
    end
  end
end
