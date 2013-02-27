require 'workless/scalers/heroku'
require 'workless/scalers/heroku_cedar'
require 'workless/scalers/local'
require 'workless/scalers/null'

module Delayed
  module Workless
    module Scaler

      def self.included(base)
        base.send :extend, ClassMethods
        unless base.to_s =~ /ActiveRecord/
          base.class_eval do
            after_destroy "self.class.scaler.down"
            after_create "self.class.scaler.up"
            after_update "self.class.scaler.down", :unless => Proc.new {|r| r.failed_at.nil? }
          end
        else
          base.class_eval do
            after_commit "self.class.scaler.down", :on => :destroy
            after_commit "self.class.scaler.up", :on => :create
            after_commit "self.class.scaler.down", :on => :update, :unless => Proc.new {|r| r.failed_at.nil? }
          end
        end

      end

      module ClassMethods
        def scaler
          @scaler ||= if ENV.include?("HEROKU_API_KEY")
            Scaler::HerokuCedar
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
