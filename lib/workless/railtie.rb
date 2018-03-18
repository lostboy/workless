require 'rails'
require 'delayed_job'

module Delayed
  class Railtie < Rails::Railtie
    initializer :after_initialize do |config|
      require 'workless/initialize'
    end
  end
end
