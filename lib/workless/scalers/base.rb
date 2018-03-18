# frozen_string_literal: true

require 'delayed_job'

module Delayed
  module Workless
    module Scaler
      class Base
        def self.jobs
          next_check_at = Time.now + ::Workless.work_off_timeout
          Delayed::Job.where(failed_at: nil).where("run_at is NULL or run_at < ?", next_check_at)
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
