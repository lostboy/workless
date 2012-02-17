require 'delayed_job'

module Delayed
  module Workless
    module Scaler
  
      class Base
        def jobs
          Delayed::Job.all(:conditions => { :failed_at => nil })
        end
      end
  
    end
  end
end