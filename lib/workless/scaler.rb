require 'workless/scalers/heroku'
require 'workless/scalers/heroku_cedar'
require 'workless/scalers/local'
require 'workless/scalers/null'

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
            client = ::Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
            case client.info(ENV["APP_NAME"])[:stack]
            when "cedar"
              Scaler::HerokuCedar
            else  
              Scaler::Heroku
            end
          else
            Scaler::Local
          end
        end

        def scaler=(scaler)
          @scaler = "Delayed::Workless::Scaler::#{scaler.to_s.camelize}".constantize
        end
      end
      
    end
    
  end
end
