require 'delayed_job'

module Delayed
  module Workless
    module Scaler

      class Base
        def self.jobs
          Delayed::Job.where(:failed_at => nil)
        end
      end

      module HerokuClient
        require 'heroku'

        def client
          @client ||= ::Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
        end

      end

    end
  end
end
