require 'rails'

module Delayed
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      puts "attempts #{Delayed::Worker.max_attempts}"
      Delayed::Backend::ActiveRecord::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::ActiveRecord::Job)
    end
  end
end