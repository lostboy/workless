require 'rails'

module Delayed
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      Delayed::Worker.max_attempts = 3
      [ Delayed::Backend::ActiveRecord::Job, Delayed::Backend::Mongoid::Job ].each do |klass|
        klass.send(:include, Delayed::Workless::Scaler) if defined?(klass)
      end
    end
  end
end
