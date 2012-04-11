require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'workless'

module Delayed
  module Job
    class Delayed::Job::Mock
      def self.after_destroy(method, *args)
      end

      def self.before_create(method, *args)
      end

      def self.after_update(method, *args)
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
