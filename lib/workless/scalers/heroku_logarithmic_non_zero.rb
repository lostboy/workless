require 'heroku'

module Delayed
  module Workless
    module Scaler

      class HerokuLogarithmic < Base

        require "heroku"

        def up
          client.set_workers(ENV['APP_NAME'], num_workers) if jobs.count > 0 && workers != num_workers
        end

        def down
          client.set_workers(ENV['APP_NAME'], 1) unless workers == 0 or jobs.count > 0
        end

        def workers
          client.info(ENV['APP_NAME'])[:workers].to_i
        end

        private

        def client
          @client ||= ::Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
        end

        def num_workers
          jobs.count == 0 ? 1 : 1 + Math.log(jobs.count).round
        end

      end

    end
  end
end
