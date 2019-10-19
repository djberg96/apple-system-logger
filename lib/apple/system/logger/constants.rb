module Apple
  module System
    module LoggerConstants
      ASL_KEY_TIME     = "Time"
      ASL_KEY_HOST     = "Host"
      ASL_KEY_SENDER   = "Sender"
      ASL_KEY_FACILITY = "Facility"
      ASL_KEY_PID      = "PID"
      ASL_KEY_UID      = "UID"
      ASL_KEY_GID      = "GID"
      ASL_KEY_LEVEL    = "Level"
      ASL_KEY_MSG      = "Message"

      ASL_LEVEL_EMERG   = 0
      ASL_LEVEL_ALERT   = 1
      ASL_LEVEL_CRIT    = 2
      ASL_LEVEL_ERR     = 3
      ASL_LEVEL_WARNING = 4
      ASL_LEVEL_NOTICE  = 5
      ASL_LEVEL_INFO    = 6
      ASL_LEVEL_DEBUG   = 7

      ASL_TYPE_MSG    0
      ASL_TYPE_QUERY  1
      ASL_TYPE_LIST   2
      ASL_TYPE_FILE   3
      ASL_TYPE_STORE  4
      ASL_TYPE_CLIENT 5
    end
  end
end
