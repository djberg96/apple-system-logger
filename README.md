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

# With all possible options, including multicast to $stderr
log = Apple::System::Logger.new(
  facility: 'com.apple.console',
  level: Apple::System::Logger::ASL_LEVEL_WARNING,
  progname: 'myprog',
  logdev: $stderr
)

log.warn("This is also a warning")

# Search for logs
log = Apple::System::Logger.new
results = log.search(:sender => 'bootlog', :level => 5)

# Always do this when finished, or use the block version of the constructor
log.close
```

## License
Apache-2.0

## Known Issues
It does not seem that you can multicast to any fileno except stdout and
stderr. I am not sure if this is by design, or if I am missing something,
because the API does not explicitly forbid other file descriptors, nor
does it raise an error.

## Copyright
(C) 2019 Daniel J. Berger, All Rights Reserved

## Warranty
This package is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantability and fitness for a particular purpose.

## Author
Daniel J. Berger
