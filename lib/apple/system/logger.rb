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

      def debug(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_DEBUG, message)
      end

      def info(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_INFO, message)
      end

      def info?
        level >= ASL_LEVEL_INFO
      end

      def warn(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_WARNING, message)
      end

      def warn?
        level >= ASL_LEVEL_WARNING
      end

      def error
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_ERR, message)
      end

      def error?
        level >= ASL_LEVEL_ERR
      end

      def fatal
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_CRIT, message)
      end

      def fatal?
        level >= ASL_LEVEL_CRIT
      end

      def unknown(message)
        asl_log(@aslclient, @aslmsg, ASL_LEVEL_EMERG, message)
      end

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
