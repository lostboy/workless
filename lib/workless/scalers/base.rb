require 'delayed_job'

module Delayed
  module Workless
    module Scaler
  
      class Base
        def self.jobs
          if Rails.version >= '3.0.0'
            self.need_run_at? ?
                Delayed::Job.where(:failed_at => nil).where('run_at < ?', Time.zone.now) :
                Delayed::Job.where(:failed_at => nil)
          else
            self.need_run_at? ?
                Delayed::Job.all(:conditions => {:failed_at => nil, :run_at_lt => Time.zone.now}) :
                Delayed::Job.all(:conditions => {:failed_at => nil})
          end
        end

        def self.need_run_at?
          @need_run_at ||= Delayed::Job.respond_to?(:run_at)
        end
      end

      module HerokuClient

        def client
          @client ||= ::Heroku::API.new(:api_key => ENV['HEROKU_API_KEY'])
        end

      end

    end
  end
end
