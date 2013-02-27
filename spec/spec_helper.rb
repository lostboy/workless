require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

Bundler.require(:default)

require 'workless'

module Delayed
  module Job
    class Delayed::Job::Mock
      def self.after_commit(method, *args, &block)
      end
    end
  end
end

class NumWorkers
  def initialize(count)
    @count = count
  end

  def count
    @count
  end
end

Delayed::Job::Mock.send(:include, Delayed::Workless::Scaler)

ENV['APP_NAME'] = 'TestHerokuApp'
