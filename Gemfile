source 'https://rubygems.org'

gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
# bundle --without mysql if using sqlite
gem 'mysql2', "~> 0.3.11", :group => :mysql 

#Authentication Gems
gem 'devise'
gem 'cancan'
gem 'rolify', '= 3.1'

#API Gems
gem 'json'
gem 'rest-client'

#Design gems
gem 'bootstrap-sass', '= 2.1.1.0'
gem 'haml-rails'
gem 'bootstrap-will_paginate'
gem 'formtastic'

# Jquery
gem 'jquery-rails'
gem 'jquery-datatables-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'font-awesome-sass-rails'
end

#JS
gem 'therubyracer'

#scheduling gems
gem 'whenever', :require => false

#Servers
gem 'unicorn'
gem 'thin', :group => :development

#testing
group :test, :development do
  gem "fake_sensu", "0.1.4"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "capybara"
  gem "poltergeist"
  gem "launchy"
end

group :test do
  gem "sinatra"
end

#debug
#gem 'rack-bug', :git => 'https://github.com/brynary/rack-bug.git', :branch => 'rails3', :group => :development

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'


# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
