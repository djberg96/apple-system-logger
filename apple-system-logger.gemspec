require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'apple-system-logger'
  spec.version    = '0.1.2'
  spec.author     = 'Daniel J. Berger'
  spec.email      = 'djberg96@gmail.com'
  spec.license    = 'Apache-2.0'
  spec.homepage   = 'https://github.com/djberg96/apple-system-logger'
  spec.summary    = 'A Ruby interface for the Apple System Logger'
  spec.test_file  = 'spec/apple-system-logger_spec.rb'
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain = ['certs/djberg96_pub.pem']

  spec.add_dependency('mutex_m')
  spec.add_dependency('ffi', '~> 1.1')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3.9')
  spec.add_development_dependency('rubocop')
  spec.add_development_dependency('rubocop-rspec')

  spec.metadata = {
    'homepage_uri'          => 'https://github.com/djberg96/apple-system-logger',
    'bug_tracker_uri'       => 'https://github.com/djberg96/apple-system-logger/issues',
    'changelog_uri'         => 'https://github.com/djberg96/apple-system-logger/blob/main/CHANGES.md',
    'documentation_uri'     => 'https://github.com/djberg96/apple-system-logger/wiki',
    'source_code_uri'       => 'https://github.com/djberg96/apple-system-logger',
    'wiki_uri'              => 'https://github.com/djberg96/apple-system-logger/wiki',
    'rubygems_mfa_required' => 'true'
  }

  spec.description = <<-EOF
    The apple-system-logger library provides an interface for the Apple System
    Library. You can both write to, and search, your mac's system logs using
    this library using an API that is very similar to the stdlib Logger interface. 
  EOF
end
