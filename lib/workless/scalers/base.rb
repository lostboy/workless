# frozen_string_literal: true

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
          @client ||= ::PlatformAPI.connect(ENV['WORKLESS_API_KEY'])
        end
      end
    end
  end
end
