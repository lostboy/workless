module Workless
  module Controllers
    module Helpers
      # Keep a timestamp of when job queue & worker count was checked
      @@last_job_work_off_timestamp = nil

      # Checks if workers need to be provisioned. Check is limited to once every 'work_off_timeout'
      def work_off_delayed_jobs
        return unless work_off_delayed_jobs?

        @@last_job_work_off_timestamp = Time.now
        Delayed::Job.scaler.up unless Delayed::Job.scaler.jobs.empty?
      end

      def work_off_delayed_jobs?
        return true unless @@last_job_work_off_timestamp.present?

        Time.now >= @@last_job_work_off_timestamp + Workless.work_off_timeout
      end
    end
  end
end
