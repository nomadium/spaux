class Chef
  class Knife
   def configure_spaux
     config.merge!(Spaux::default_chef_config(:knife))
   end
   def self.run(args, options={})
      # Fallback debug logging. Normally the logger isn't configured until we
      # read the config, but this means any logging that happens before the
      # config file is read may be lost. If the KNIFE_DEBUG variable is set, we
      # setup the logger for debug logging to stderr immediately to catch info
      # from early in the setup process.
      if ENV['KNIFE_DEBUG']
        Chef::Log.init($stderr)
        Chef::Log.level(:debug)
      end

      load_commands
      subcommand_class = subcommand_class_from(args)
      subcommand_class.options = options.merge!(subcommand_class.options)
      subcommand_class.load_deps
      instance = subcommand_class.new(args)
      instance.configure_spaux
      instance.configure_chef
      instance.run_with_pretty_exceptions
    end
  end
end
