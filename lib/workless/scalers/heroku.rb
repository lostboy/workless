require 'heroku'

module Delayed
  module Workless
    module Scaler

      class Heroku < Base

        extend Delayed::Workless::Scaler::HerokuClient

        def up
          w = workers
          if w == 0
            client.set_workers(ENV['APP_NAME'], 1)
          elsif w < 2 and jobs.count > 200
            client.set_workers(ENV['APP_NAME'], 10)
          end
        end

        def down
          client.set_workers(ENV['APP_NAME'], 0) unless jobs.count > 0
        end

        def self.workers
          client.info(ENV['APP_NAME'])[:workers].to_i
        end

      end

    end
  end
end
