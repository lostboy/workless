require "heroku-api"
require File.dirname(__FILE__) + "/workless/scalers/base"
require File.dirname(__FILE__) + "/workless/scaler"
require File.dirname(__FILE__) + "/workless/railtie" if defined?(Rails::Railtie)