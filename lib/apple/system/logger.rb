require_relative 'logger/functions'
require_relative 'logger/constants'

module Apple
  module System
    class Logger
      include Apple::System::LoggerFunctions
      include Apple::System::LoggerConstants

      # The version of this library.
      VERSION = '0.1.0'.freeze

      # A syslogd facility. The system default is 'user'.
      attr_reader :facility

      # The logging severity threshold. The default is debug.
      attr_reader :level

      # The program name, or ident, that becomes the key sender. The default is nil.
      attr_reader :progname

      # If provided, a file or filehandle that the logger will multicast to. The default is nil.
      attr_reader :logdev

      # Create and return an Apple::System::Logger instance. The constructor takes a series
      # of optional arguments:
      #
      # * facility
      # * level
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
      # You may optionally use a block, which will yield the logger instance and
      # automatically close itself.
      #
      # Example:
      #
      #   # Typical
      #   log = Apple::System::Logger.new(facility: 'com.apple.console', progname: 'my-program')
      #   log.warn("Some warning message")
      #
      #   # Block form
      #   Apple::System::Logger.new(facility: 'com.apple.console', progname: 'my-program') do |log|
      #     log.warn("Some warning message")
      #   end
      #--
      # TODO: Add string format support and apply it to messages.
      #
      def initialize(**kwargs)
        @facility = kwargs[:facility]
        @level    = kwargs[:level] || ASL_LEVEL_DEBUG
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

        if block_given?
          begin
            yield self
          ensure
            close
          end
        end
      end

      # Dump a message with no formatting at the current severity level.
      #
      def <<(message)
        asl_log(@aslclient, @aslmsg, @level, message)
      end

      # Log a message at the given level.
      #
      def add(level, message)
        asl_log(@aslclient, @aslmsg, level, message)
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

      # Search the logs using the provided query. The query should be a hash of
      # options. Returns an array of hashes.
      #
      # Example:
      #
      #   log = Apple::System::Logger.new
      #
      #   options = {
      #     :sender => 'bootlog'
      #     :level  => 5
      #   }
      #
      #   results = log.search(options)
      #
      #   # Sample output
      #
      #   [{
      #     "ASLMessageID"  => "1",
      #     "Time"          => "1570858104",
      #     "TimeNanoSec"   => "0",
      #     "Level"         => "5",
      #     "PID"           => "0",
      #     "UID"           => "0",
      #     "GID"           => "0",
      #     "ReadGID"       => "80",
      #     "Host"          => "localhost",
      #     "Sender"        => "bootlog",
      #     "Facility"      => "com.apple.system.utmpx",
      #     "Message"       => "BOOT_TIME 1570858104 0",
      #     "ut_id"         => "0x00 0x00 0x00 0x00",
      #     "ut_pid"        => "1",
      #     "ut_type"       => "2",
      #     "ut_tv.tv_sec"  => "1570858104",
      #     "ut_tv.tv_usec" => "0",
      #     "ASLExpireTime" => "1602480504"
      #   }]
      #
      # Only equality checks are used for most options. In the future, I will allow
      # for more advanced queries, such as substrings and <, >, <=, >=.
      #
      # Note that Time objects are queried using "greater than or equal to" for now.
      #
      # Example:
      #
      #   # Find all logs from uid 501 from the last hour.
      #   log.search(:uid => 501, :time => Time.now - 3600)
      #
      def search(query)
        value  = nil
        aslmsg = asl_new(ASL_TYPE_QUERY)
        result = []

        query.each do |key, value|
          asl_key = map_key_to_asl_key(key)
          flags = ASL_QUERY_OP_EQUAL
          flags = (flags | ASL_QUERY_OP_NUMERIC) if value.is_a?(Numeric)
          flags = (flags | ASL_QUERY_OP_TRUE) if value == true

          if value.is_a?(Time)
            flags = (flags | ASL_QUERY_OP_GREATER_EQUAL)
            value = value.to_i
          end

          if value.is_a?(Regexp)
            flags = (flags | ASL_QUERY_OP_REGEX)
            flags = (flags | ASL_QUERY_OP_CASEFOLD) if value.casefold?
          end

          asl_set_query(aslmsg, asl_key, value.to_s, flags)
        end

        response = asl_search(@aslclient, aslmsg)

        while m = aslresponse_next(response)
          break if m.null?
          i = 0
          hash = {}
          while key = asl_key(m, i)
            break if key.nil? || key.empty?
            value = asl_get(m, key)
            hash[key] = value
            i += 1
          end
          result << hash
        end

        result
      ensure
        aslresponse_free(response) if response
        asl_free(aslmsg)
      end

      # Close the logger instance. You should always do this.
      #
      def close
        asl_free(@aslmsg) if @aslmsg
        asl_close(@aslclient) if @aslclient
        @aslmsg = nil
        @aslclient = nil
      end

      private

      def map_key_to_asl_key(key)
        {
          :time     => ASL_KEY_TIME,
          :host     => ASL_KEY_HOST,
          :sender   => ASL_KEY_SENDER,
          :facility => ASL_KEY_FACILITY,
          :pid      => ASL_KEY_PID,
          :uid      => ASL_KEY_UID,
          :gid      => ASL_KEY_GID,
          :level    => ASL_KEY_LEVEL,
          :message  => ASL_KEY_MSG
        }[key]
      end
    end
  end
end
