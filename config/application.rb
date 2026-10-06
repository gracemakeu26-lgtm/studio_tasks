require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module StudioTasks
  class Application < Rails::Application
    config.i18n.default_locale = :fr
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
