require_relative 'logger/functions'

module Apple
  module System
    class Logger
      include Apple::System::LoggerFunctions
    end
  end
end
