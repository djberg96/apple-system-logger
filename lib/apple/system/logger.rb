require_relative 'logger/functions'
require_relative 'logger/constants'

module Apple
  module System
    class Logger
      include Apple::System::LoggerFunctions
      include Apple::System::LoggerConstants

      attr_accessor :facility
      attr_accessor :level
      attr_accessor :format

      def initialize(**kwargs)
        @facility = kwargs[:facility]
        @level    = kwargs[:level]
        @format   = kwargs[:format]

        asl_set_filter(nil, @level) if @level
      end

      def info(message)
        asl_log(nil, nil, ASL_LEVEL_INFO, message)
      end

      def warn(message)
        asl_log(nil, nil, ASL_LEVEL_WARNING, message)
      end
    end
  end
end

if $0 == __FILE__
  log = Apple::System::Logger.new(level: Apple::System::Logger::ASL_LEVEL_NOTICE)
  log.info("GREETINGS DANIEL - INFO")
  log.warn("GREETINGS DANIEL - WARN")
end
