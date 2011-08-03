require 'heroku'

module Delayed
  module Workless
    module Scaler
      class HerokuLogarithmicNonZero < Base

        extend Delayed::Workless::Scaler::HerokuClient

        require "heroku"

        def self.up
          self.client.set_workers(ENV['APP_NAME'], num_workers) if self.jobs.count > 0 && self.workers != num_workers
        end

        def self.down
          self.client.set_workers(ENV['APP_NAME'], 1) unless self.workers == 1 or self.jobs.count > 0
        end

        def self.workers
          self.client.info(ENV['APP_NAME'])[:workers].to_i
        end

      private

        def self.num_workers
          self.jobs.count <= 1 ? 1 : Math.log(self.jobs.count).round
        end

      end

    end
  end
end
