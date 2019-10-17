require_relative 'logger/functions'
require_relative 'logger/constants'

module Apple
  module System
    class Logger
      include Apple::System::LoggerFunctions
      include Apple::System::LoggerConstants
    end
  end
end
