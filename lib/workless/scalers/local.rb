require 'rush'

module Delayed
  module Workless
    module Scaler

      class Local < Base

        def up
          Rush::Box.new[Rails.root].bash("rake jobs:work", :background => true) if workers == 0
          true
        end

        def down
          #Rush::Box.new.processes.filter(:cmdline => /rake jobs:work/).kill unless workers == 0 or jobs.count > 0
          #instead of just killing the process which exited the thing way too fast and didn't remove the entry from the database table
          #now we will just set exit to true so that it will exit the loop in the run method in delayed_job
          #and I used jobs.count - 1 because when the after_destroy hook is trigged the job is not yet actually destroyed.
          #this works much better for my local development system, OS X Lion. 
          $exit = true unless workers == 0 or jobs.count - 1 > 0
          true
        end

        def workers
          Rush::Box.new.processes.filter(:cmdline => /rake jobs:work/).size
        end

      end
  
    end
  end
end