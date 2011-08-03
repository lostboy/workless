require 'rubygems'
require 'rake'
require 'bundler'

begin
  require 'jeweler'
  
  Jeweler::Tasks.new do |gem|
    gem.name = "workless"
    gem.summary = %Q{Use delayed job workers only when theyre needed}
    gem.description = %Q{Extension to Delayed Job to enable workers to scale up when needed}
    gem.email = "paul.crabtree@gmail.com"
    gem.homepage = "http://github.com/lostboy/workless"
    gem.authors = ["lostboy"]
    gem.add_bundler_dependencies
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
end

task :default => :spec
