require 'rush'

module Delayed
  module Workless
    module Scaler

      class Local < Base

        def up
          if workers == 0
            Rush::Box.new[Rails.root].bash("rake jobs:work", :background => true)
          elsif workers < 2 and jobs.count > 500
            for i in (1..10)
              Rush::Box.new[Rails.root].bash("rake jobs:work", :background => true)
            end
          end
          
          true
        end

        def down
          Rush::Box.new.processes.filter(:cmdline => /rake jobs:work/).kill unless workers == 0 or jobs.count > 0
          true
        end

        def workers
          Rush::Box.new.processes.filter(:cmdline => /rake jobs:work/).size
        end

      end
  
    end
  end
end