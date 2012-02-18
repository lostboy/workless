require 'rush'

module Delayed
  module Workless
    module Scaler

      class Local < Base

        def self.up
          if self.workers == 0
            Rush::Box.new[Rails.root].bash("script/delayed_job start -i workless", :background => true)
            sleep 1
          end
          true
        end

        def self.down
          unless jobs.count > 0 and workers > 0
            Rush::Box.new[Rails.root].bash("script/delayed_job stop -i workless", :background => true)
          end
          true
        end

        def self.workers
          Rush::Box.new.processes.filter(:cmdline => /delayed_job start -i workless|delayed_job.workless/).size
        end

      end
  
    end
  end
end
