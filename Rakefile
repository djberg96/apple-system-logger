require 'rake'
require 'rake/clean'
require 'rbconfig'
require 'rspec/core/rake_task'
include RbConfig

RSpec::Core::RakeTask.new(:spec)

CLEAN.include('**/*.gem', '**/*.rbc', '**/*.rbx')

namespace 'gem' do
  desc "Create the apple-system-library gem"
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('apple-system-library.gemspec'))
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec, true)
  end

  desc "Install the apple-system-library gem"
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

task :default => :spec
