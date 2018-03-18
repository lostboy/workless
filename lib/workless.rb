# frozen_string_literal: true

require File.dirname(__FILE__) + '/workless/scalers/base'
require File.dirname(__FILE__) + '/workless/scaler'
require File.dirname(__FILE__) + '/workless/controllers/helpers'
require File.dirname(__FILE__) + '/workless/railtie' if defined?(Rails::Railtie)

ActiveSupport.on_load(:action_controller) do
  include Workless::Controllers::Helpers
end

module Workless
  # The minimum timeout between Workless checking if jobs need to be worked
  mattr_accessor :work_off_timeout
  @@work_off_timeout = 1.minute

  # The name of your Heroku application which will be scaled
  mattr_accessor :heroku_app_name
  @@heroku_app_name = ENV['HEROKU_APP_NAME']
end
