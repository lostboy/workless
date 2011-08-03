require 'rush'

module Delayed
  module Workless
    module Scaler

      class Local < Base

        def self.up
          Rush::Box.new[Rails.root].bash("rake jobs:work", :background => true) if self.workers == 0
          true
        end

        def down
          $exit = true unless jobs.count > 0
          true
        end

        def self.workers
          Rush::Box.new.processes.filter(:cmdline => /rake jobs:work/).size
        end

      end
  
    end
  end
end
