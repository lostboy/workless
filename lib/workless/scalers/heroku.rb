require 'heroku-api'

module Delayed
  module Workless
    module Scaler

      class Heroku < Base

        extend Delayed::Workless::Scaler::HerokuClient

        def self.up
          client.set_workers(ENV['APP_NAME'], 1) if self.workers == 0
        end

        def self.down
          client.set_workers(ENV['APP_NAME'], 0) unless self.workers == 0 or self.jobs.count > 0
        end

        def self.workers
          client.info(ENV['APP_NAME'])[:workers].to_i
        end

      end

    end
  end
end
