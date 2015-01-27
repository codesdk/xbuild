module XBuild

  class SystemCommandExecutor

    def execute(command)
      system(command)
    end

  end

  class StdOutLogger

    def log(message)
      puts message
    end

  end

  class Runner

    ACTIONS = %w(
      clean
      build
      test
      archive
      analyze
      install
    )

    DEFAULT_ACTION_ARGUMENTS = {
      'test' => {
        'sdk' => 'iphonesimulator'
      }
    }

    attr_reader :workspace, :scheme, :command_executor, :action_arguments, :logger

    def initialize(workspace, scheme, opts = {})
      @workspace = workspace
      @scheme = scheme
      opts = {verbose: false, dry_run: false, pretty: true, xctool: false}.merge(opts)
      @pretty = opts[:pretty]
      @verbose = opts[:verbose]
      @dry_run = opts[:dry_run]
      @xctool = opts[:xctool]
      @action_arguments = opts[:action_arguments] || {}
      @command_executor = opts[:command_executor] || SystemCommandExecutor.new
      @logger = opts[:logger] || StdOutLogger.new
    end

    def xctool?
      @xctool
    end

    def pretty?
      !xctool? && @pretty
    end

    def run(action, arguments = {}, options = {})
      success = false
      if valid_action?(action)
        options = default_base_options.merge(options)
        arguments = merge_action_arguments(action, arguments)
        command = build_command(action, arguments, options)
        success = execute(command)
      else
        raise "Invalid action #{action}"
      end
      success
    end

    def dry_run?
      @dry_run
    end

    def verbose?
      @verbose
    end

    ACTIONS.each do |action|
      define_method(action) do |*args|
        run(action, *args)
      end
    end

    private

      def merge_action_arguments(action, arguments)
        args = action_arguments.fetch(action, {}).merge(arguments)
        DEFAULT_ACTION_ARGUMENTS.fetch(action, {}).merge(args)
      end

      def build_command(action, arguments, options)
        options = to_options_string(options)
        arguments = to_options_string(arguments)
        cmd = "#{build_tool}#{options} #{action}#{arguments}".strip
        cmd = pipe_xcpretty(cmd) if pretty?
        cmd
      end

      def build_tool
        if xctool?
          "xctool"
        else
          "xcodebuild"
        end
      end

      def execute(command)
        log("Executing command '#{command}'")
        command_executor.execute(command) unless dry_run?
      end

      def valid_action?(action)
        ACTIONS.include?(action)
      end

      def log(message)
        logger.log "#{self.class}: #{message}" if verbose?
      end

      def default_base_options
        @default_base_options ||= { workspace: workspace, scheme: scheme }
      end

      def pipe_xcpretty(cmd)
        "set -o pipefail && #{cmd} | xcpretty -c"
      end

      def to_options_string(options = {})
        options.reduce("") do |options_string, (key, value)|
          if value
            options_string + " -#{key} #{value}"
          else
            options_string + " -#{key}"
          end
        end
      end

  end
end
