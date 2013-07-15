# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'
include ActionView::Helpers::DateHelper

Capybara.configure do |config|
  config.ignore_hidden_elements = true
end
Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# seed database

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.before :suite do
    puts "starting fake sensu api!"
    setting = Setting.find_or_create_by_name("api_server")
    setting.value = "localhost:9292"
    setting.save
    $fake_sensu_pid = Process.spawn("rackup --env production #{Rails.root}/spec/fake_sensu/config.ru", :out => "/dev/stdout")
    sleep 1
  end

  config.after :suite do
    puts "\nstopping fake sensu api @ #{$fake_sensu_pid}!"
    Process.kill 9, $fake_sensu_pid
  end


  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # include controller test helpers
  config.include FakeSensuMacros
  config.include Devise::TestHelpers, :type => :controller
  config.include DeviseMacros, :type => :feature
  config.extend ControllerMacros, :type => :controller

end
