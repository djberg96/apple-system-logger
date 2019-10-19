require_relative 'logger/functions'
require_relative 'logger/constants'

module Apple
  module System
    class Logger
      include Apple::System::LoggerFunctions
      include Apple::System::LoggerConstants

      # A syslogd facility. The system default is 'user'.
      attr_accessor :facility

      # The logging severity threshold. The default is debug.
      attr_accessor :level

      # A printf style formatting string that will be applied to messages. The system default is '%s'.
      attr_accessor :format

      # The program name, or ident, that becomes the key sender. The default is nil.
      attr_accessor :progname

      # If provided, a file or filehandle that the logger will multicast to. The default is nil.
      attr_accessor :logdev

      # Create and return an Apple::System::Logger instance. The constructor takes a series
      # of optional arguments:
      #
      # * facility
      # * level
      # * format
      # * progname
      # * logdev
      #
      # Note that the logdev only seems to work with $stdout or $stderr, if provided.
      #
      # For the severity level, the possible values are:
      #
      # * ASL_LEVEL_EMERG
      # * ASL_LEVEL_ALERT
      # * ASL_LEVEL_CRIT
      # * ASL_LEVEL_ERR
      # * ASL_LEVEL_WARNING
      # * ASL_LEVEL_NOTICE
      # * ASL_LEVEL_INFO
      # * ASL_LEVEL_DEBUG
      #
      # Example:
      #
      #   log = Apple::System::Logger.new(facility: 'com.apple.console', progname: 'my-program')
      #
      #   log.warn("Some warning message")
      #
      def initialize(**kwargs)
        @facility = kwargs[:facility]
        @level    = kwargs[:level] || ASL_LEVEL_DEBUG
        @format   = kwargs[:format]
        @progname = kwargs[:progname]
        @logdev   = kwargs[:logdev]

        if @logdev || @facility || @progname
          options = ASL_OPT_NO_DELAY | ASL_OPT_NO_REMOTE
          @aslclient = asl_open(@progname, @facility, options)

          if @logdev
            asl_add_log_file(@aslclient, @logdev.fileno)
          end
        else
          @aslclient = nil
        end

        @aslmsg = asl_new(ASL_TYPE_MSG)
        asl_set(@aslmsg, ASL_KEY_FACILITY, @facility) if @facility
        asl_set_filter(@aslclient, @level)
      end

      # Log a debug message.
      #
      def debug(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_DEBUG, message)
      end

      # Returns true if the current severity level allows for the printing of debug messages.
      #
      def debug?
        level >= ASL_LEVEL_DEBUG
      end

      # Log an info message.
      #
      def info(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_INFO, message)
      end

      # Returns true if the current severity level allows for the printing of info messages.
      #
      def info?
        level >= ASL_LEVEL_INFO
      end

      # Log a warning message.
      #
      def warn(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_WARNING, message)
      end

      # Returns true if the current severity level allows for the printing of warning messages.
      #
      def warn?
        level >= ASL_LEVEL_WARNING
      end

      # Log an error message.
      #
      def error
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_ERR, message)
      end

      # Returns true if the current severity level allows for the printing of erro messages.
      #
      def error?
        level >= ASL_LEVEL_ERR
      end

      # Log a fatal message. For this library that means an ASL_LEVEL_CRIT message.
      #
      def fatal
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_CRIT, message)
      end

      # Returns true if the current severity level allows for the printing of fatal messages.
      #
      def fatal?
        level >= ASL_LEVEL_CRIT
      end

      # Log an unknown message. For this library that means an ASL_LEVEL_EMERG message.
      #
      def unknown(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_EMERG, message)
      end

      # Close the logger instance. You should always do this.
      #
      def close
        asl_close(@aslclient) if @aslclient
      end
    end
  end
end

if $0 == __FILE__
  #log = Apple::System::Logger.new(level: Apple::System::Logger::ASL_LEVEL_NOTICE)
  #log = Apple::System::Logger.new(logdev: $stdout, progname: "rubyprog", facility: "dberger.test")
  #log = Apple::System::Logger.new(logdev: $stderr, progname: "rubyprog", facility: "dberger.test")
  log = Apple::System::Logger.new(logdev: File.open('temp.log', 'w'), progname: "rubyprog", facility: "dberger.test")
  #p log.info?
  #p log.warn?
  #log.info("GREETINGS DANIEL - INFO")
  log.warn("GREETINGS DANIEL - WARN7")
  log.close
end
