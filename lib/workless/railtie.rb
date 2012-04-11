require 'rails'
require 'delayed_job'

module Delayed
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      require 'workless/initialize'
    end
  end
end
