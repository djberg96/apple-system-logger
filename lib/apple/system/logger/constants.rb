# frozen_string_literal: true

module Apple
  module System
    module LoggerConstants
      ASL_KEY_TIME     = 'Time'
      ASL_KEY_HOST     = 'Host'
      ASL_KEY_SENDER   = 'Sender'
      ASL_KEY_FACILITY = 'Facility'
      ASL_KEY_PID      = 'PID'
      ASL_KEY_UID      = 'UID'
      ASL_KEY_GID      = 'GID'
      ASL_KEY_LEVEL    = 'Level'
      ASL_KEY_MSG      = 'Message'

      ASL_LEVEL_EMERG   = 0
      ASL_LEVEL_ALERT   = 1
      ASL_LEVEL_CRIT    = 2
      ASL_LEVEL_ERR     = 3
      ASL_LEVEL_WARNING = 4
      ASL_LEVEL_NOTICE  = 5
      ASL_LEVEL_INFO    = 6
      ASL_LEVEL_DEBUG   = 7

      ASL_TYPE_MSG    = 0
      ASL_TYPE_QUERY  = 1
      ASL_TYPE_LIST   = 2
      ASL_TYPE_FILE   = 3
      ASL_TYPE_STORE  = 4
      ASL_TYPE_CLIENT = 5

      ASL_OPT_STDERR    = 0x00000001
      ASL_OPT_NO_DELAY  = 0x00000002
      ASL_OPT_NO_REMOTE = 0x00000004

      ASL_QUERY_OP_CASEFOLD  = 0x0010
      ASL_QUERY_OP_PREFIX    = 0x0020
      ASL_QUERY_OP_SUFFIX    = 0x0040
      ASL_QUERY_OP_SUBSTRING = 0x0060
      ASL_QUERY_OP_NUMERIC   = 0x0080
      ASL_QUERY_OP_REGEX     = 0x0100

      ASL_QUERY_OP_EQUAL         = 0x0001
      ASL_QUERY_OP_GREATER       = 0x0002
      ASL_QUERY_OP_GREATER_EQUAL = 0x0003
      ASL_QUERY_OP_LESS          = 0x0004
      ASL_QUERY_OP_LESS_EQUAL    = 0x0005
      ASL_QUERY_OP_NOT_EQUAL     = 0x0006
      ASL_QUERY_OP_TRUE          = 0x0007
    end
  end
end
