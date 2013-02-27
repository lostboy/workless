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

require 'coveralls'
Coveralls.wear!

require 'workless'

module Delayed
  module ActiveRecord
    module Job
      class Delayed::ActiveRecord::Job::Mock
        def self.after_commit(method, *args, &block)
        end
      end
    end
  end
end

module Delayed
  module Mongoid
    module Job
      class Delayed::Mongoid::Job::Mock
        def self.after_destroy(method, *args)
        end
        def self.after_create(method, *args)
        end
        def self.after_update(method, *args)
        end
      end
    end
  end
end

module Delayed
  module MongoMapper
    module Job
      class Delayed::MongoMapper::Job::Mock
        def self.after_destroy(method, *args)
        end
        def self.after_create(method, *args)
        end
        def self.after_update(method, *args)
        end
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

class FutureJob
  def run_at
    Time.now + 1000 * 60 * 60
  end

  def count
    0
  end
end


Delayed::ActiveRecord::Job::Mock.send(:include, Delayed::Workless::Scaler)
Delayed::Mongoid::Job::Mock.send(:include, Delayed::Workless::Scaler)
Delayed::MongoMapper::Job::Mock.send(:include, Delayed::Workless::Scaler)

ENV['APP_NAME'] = 'TestHerokuApp'
