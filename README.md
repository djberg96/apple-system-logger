## apple-system-logger
A Ruby interface for the Apple system logger.

## Installation
gem install apple-system-logger

## Synopsis
```
require 'apple-system-logger'

# With defaults
log = Apple::System::Logger.new
log.warn("This is a warning")

# With some options, multicast to $stderr
log = Apple::System::Logger.new(facility: 'com.apple.console', level: ASL_LEVEL_WARNING, progname: 'myprog', logdev: $stderr)
log.warn("This is also a warning")

# Search for logs
log = Apple::System::Logger.new
results = log.search(:sender => 'bootlog', :level => 5)

# Always do this when finished, or use the block version of the constructor
log.close
```

## Author
Daniel J. Berger

## License
Apache-2.0
