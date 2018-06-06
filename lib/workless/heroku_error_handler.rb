module Workless
  # Default behaviour to handle Heroku errors is to raise the error. This can be changed by implementing your own class which defines .handle and then updating Workless.heroku_error_handler configuration to link your custom class
  class HerokuErrorHandler

    # Raises error
    #
    # @param error [Error] raised from communicating with Heroku
    def self.handle(error)
      raise error
    end
  end
end
