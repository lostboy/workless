require 'heroku'

module Delayed
  module Workless
    module Scaler

      class HerokuCedar < Base

        extend Delayed::Workless::Scaler::HerokuClient

        def self.up
          client.ps_scale(ENV['APP_NAME'], :type => 'worker', :qty => 1) if self.workers == 0
        end

        def self.down
          client.ps_scale(ENV['APP_NAME'], :type => 'worker', :qty => 0) unless self.workers == 0 or self.jobs.count > 0
        end

        def self.workers
          client.ps(ENV['APP_NAME']).count { |p| p["process"] =~ /worker\.\d?/ }
        end

      end

    end
  end
end
