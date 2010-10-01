module Delayed
  module Workless 
    module Scaler
    
      def self.included(base)
        
        base.send :extend, ClassMethods
        base.class_eval do
          after_destroy "self.class.scaler.down"
          before_create "self.class.scaler.up"
          after_update "self.class.scaler.down", :unless => Proc.new {|r| r.failed_at.nil? }
        end
        
      end
      
      module ClassMethods
        def scaler
          @scaler ||= if ENV.include?("HEROKU_UPID")
            require File.dirname(__FILE__) + "/scalers/heroku"
            Scaler::Heroku.new
          else
            require File.dirname(__FILE__) + "/scalers/local"
            Scaler::Local.new
          end
        end

        def scaler=(scaler)
          require File.dirname(__FILE__) + "/scalers/#{scaler.to_s}"
          @scaler = "Delayed::Workless::Scaler::#{scaler.to_s.camelize}".constantize.new
        end
      end
      
    end
    
  end
end
