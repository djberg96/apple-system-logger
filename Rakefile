require 'rake'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

CLEAN.include('**/*.gem', '**/*.rbc', '**/*.rbx', '**/*.lock')

namespace 'gem' do
  desc "Create the apple-system-logger gem"
  task :create => [:clean] do
    require 'rubygems/package'
    spec = Gem::Specification.load('apple-system-logger.gemspec')
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec)
  end

  desc "Install the apple-system-logger gem"
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

RuboCop::RakeTask.new

task :default => :spec
