require 'delayed_job'

module Delayed
  module Workless
    module Scaler
      class Base
        def self.jobs
          Delayed::Job.where(failed_at: nil)
        end
      end

      module HerokuClient
        def client
          @client ||= ::Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
        end
      end
    end
  end
end
