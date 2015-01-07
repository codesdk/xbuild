require 'clamp'
require 'yaml'
require 'xbuild'

module XBuild

  class CLI < Clamp::Command

    CONFIG_FILE_NAME = ".xbuild.yml"

    option  ["-x", "--dry-run"],
            :flag,
            "Runs all the process without actually calling the build tool.",
            argument_name: :dry_run
    option  ["-p", "--pretty"],
            :flag,
            "Uses xcpretty to format build output (only when using xcodebuild).",
            argument_name: :pretty
    option  ["-v", "--verbose"],
            :flag,
            "Enables verbose mode.",
            argument_name: :verbose
    option  ["-F", "--xctool"],
            :flag,
            "Uses xctool instead of xcodebuild as the build tool.",
            argument_name: :xctool

    parameter "ACTION", "The build action to be run."
    parameter "[WORKSPACE]", "Sets the project's workspace."
    parameter "[SCHEME]", "Sets the project's scheme."

    def execute
      parse_config_file!
      validate!
      exit(1) unless runner.run(action)
    end

    private

      def validate!
        [:workspace, :scheme].each do |parameter|
          if send(parameter).nil?
            puts "Error: Parameter '#{parameter}' must be set either using '#{CONFIG_FILE_NAME}' or through command line."
            exit(1)
          end
        end
      end

      def parse_config_file!
        return unless File.exist?(CONFIG_FILE_NAME)
        config = load_yaml_file(CONFIG_FILE_NAME)
        set_parameter_value(config, :workspace)
        set_parameter_value(config, :scheme)
        # clan's default options are not used
        # because if a config file is defined
        # we want command line options to
        # have precedence over options defined
        # in the config file. That is why
        # default value are manually applied
        # after merging config file options
        # with command line options
        @options = default_options.merge(config.merge(options))
      end

      def options
        return @options if @options
        @options = {}
        @options[:dry_run] = dry_run? unless dry_run?.nil?
        @options[:verbose] = verbose? unless verbose?.nil?
        @options[:pretty] = pretty? unless pretty?.nil?
        @options[:xctool] = xctool? unless xctool?.nil?
        @options
      end

      def default_options
        {
          dry_run: false,
          verbose: false,
          pretty: true,
          xctool: false
        }
      end

      def runner
        @runner ||= Runner.new(workspace, scheme, options)
      end

      def load_yaml_file(file)
        yaml = YAML.load_file(file)
        Hash[yaml.map{ |k, v| [k.to_sym, v] }]
      end

      def set_parameter_value(config, parameter)
        value = config.delete(parameter)
        if send(parameter).nil?
          instance_variable_set("@#{parameter}", value)
        end
      end

  end

end
