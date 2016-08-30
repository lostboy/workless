require 'rails'
require 'delayed_job'

module Delayed
  class Railtie < Rails::Railtie
    initializer :after_initialize do |config|
      require 'workless/initialize'
      config.middleware.use 'WorklessChecker'
    end
  end
end
