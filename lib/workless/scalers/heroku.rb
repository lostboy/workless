require 'heroku'

module Delayed
  module Workless
    module Scaler

      class Heroku < Base

        require "heroku"

        def up
          if workers == 0
            client.set_workers(ENV['APP_NAME'], 1)
          elsif workers < 2 and jobs.count > 500
            client.set_workers(ENV['APP_NAME'], 10)
          end
        end

        def down
          client.set_workers(ENV['APP_NAME'], 0) unless workers == 0 or jobs.count > 0
        end

        def workers
          client.info(ENV['APP_NAME'])[:workers].to_i
        end

        private

        def client
          @client ||= ::Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
        end

      end

    end
  end
end