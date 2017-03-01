require File.dirname(__FILE__) + '/workless/scalers/base'
require File.dirname(__FILE__) + '/workless/scaler'
require File.dirname(__FILE__) + '/workless/middleware/workless_checker' if defined?(Rails::Railtie)
require File.dirname(__FILE__) + '/workless/railtie' if defined?(Rails::Railtie)
