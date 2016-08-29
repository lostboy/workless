require 'rubygems'
require 'rake'
require 'bundler/setup'

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
end

task :default => :spec