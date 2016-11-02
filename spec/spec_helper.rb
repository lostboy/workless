require 'rubygems'
require 'bundler/setup'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'coveralls'
Coveralls.wear!

require 'active_support'

Bundler.require(:default)

require 'workless_revived'

module Delayed
  module ActiveRecord
    module Job
      class Delayed::ActiveRecord::Job::Mock
        def self.after_commit(_method, *_args, &_block)
        end
      end
    end
  end
end

module Delayed
  module Mongoid
    module Job
      class Delayed::Mongoid::Job::Mock
        def self.after_destroy(_method, *_args)
        end

        def self.after_create(_method, *_args)
        end

        def self.after_update(_method, *_args)
        end
      end
    end
  end
end

module Delayed
  module MongoMapper
    module Job
      class Delayed::MongoMapper::Job::Mock
        def self.after_destroy(_method, *_args)
        end

        def self.after_create(_method, *_args)
        end

        def self.after_update(_method, *_args)
        end
      end
    end
  end
end

module Delayed
  module Sequel
    module Job
      class Delayed::Sequel::Job::Mock
      end
    end
  end
end

class NumWorkers
  def initialize(count)
    @count = count
  end

  attr_reader :count
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
Delayed::Sequel::Job::Mock.send(:include, Delayed::Workless::Scaler)

ENV['APP_NAME'] = 'TestHerokuApp'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end
end
