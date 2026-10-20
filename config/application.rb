require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module FestivalSprint
  class Application < Rails::Application
    config.load_defaults 7.1

    # No views or assets are needed for this exercise.
    config.api_only = true
  end
end
