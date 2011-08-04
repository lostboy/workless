require 'rails'

module Delayed
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      Delayed::Worker.max_attempts = 3
      Delayed::Backend::ActiveRecord::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::ActiveRecord::Job)
      Delayed::Backend::Mongoid::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::Mongoid::Job)
    end
  end
end
