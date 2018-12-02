require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TechDejanKrivec
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.enable_dependency_loading = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
    #autoloads lib folder during production
    config.eager_load_paths << Rails.root.join('lib')

    #autoloads lib folder during development
    config.autoload_paths << Rails.root.join('lib')

    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true, # specifies to generate a fixture for each model (using a Factory Girl factory, instead of an actual fixture
        :view_specs => false, # says to skip generating view specs. I won’t cover them in this book; instead we’ll use request specs to test interface elements
        :helper_specs => false, # skips generating specs for the helper files Rails generates with each controller. As your comfort level with RSpec improves, consider changing this option to true and testing these files.
        :routing_specs => false, # omits a spec file for your config/routes.rb file. If your application is simple, as the one in this book will be, you’re probably safe skipping these specs. As your application grows, however, and takes on more complex routing, it’s a good idea to incorporate routing specs.
        :controller_specs => true, #
        :request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories" # tells Rails to generate factories instead of fixtures, and to save them in the spec/factories directory.
    end
  end
end
