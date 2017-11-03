source 'https://rubygems.org'

ruby '2.4.0'

# The Ruby on Rails web development framework
# everything needed to create database-backed web applications according to the Model-View-Controller (MVC) pattern
# https://github.com/rails/rails
gem 'rails', '~> 5.0.0'
# Default server for Rails, built for concurrency
# https://github.com/puma/puma
gem 'puma'

gem 'coveralls', require: false

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.5'
# https://github.com/kossnocorp/jquery.turbolinks
gem 'jquery-turbolinks'
gem 'jquery-ui-rails' #TODO link + Comment

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
#gem 'sdoc', '~> 0.4.0', group: :doc

# for Windows users
#gem 'nokogiri', '1.6.7.rc3', platforms: [:mswin, :mingw, :x64_mingw]
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# Authentication
gem 'devise'
# openID Authentication
gem 'devise_openid_authenticatable'

# Use Bootstrap (app/assets/stylesheets)
#gem 'therubyracer', '~> 0.12.2', platforms: :ruby
gem 'twitter-bootstrap-rails'
gem 'devise-bootstrap-views'
#use Bootstrap Tooltips
gem 'bootstrap-tooltip-rails' #TODO comment
#gem 'bootstrap-datepicker-rails'

# Select2 dropdown replacement featuring autocomplete
#gem 'select2-rails'

# Exception Tracking
gem 'airbrake'

# to parse date parameters from ui
#gem "delocalize"

# Continuation of CanCan (authoriation Gem for RoR)
gem 'cancancan'

# Create filters easily with scopes
gem 'has_scope'

#Code analyzer
gem 'rubocop'

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  #gem 'database_cleaner'
  gem 'factory_bot_rails'

  gem 'i18n-tasks'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'


  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Used for hot reload on the development server
  gem 'listen', '~> 3.0.5'

  gem 'better_errors' #TODO
  gem 'binding_of_caller' #is required by better_errors

  # an IRB alternative and runtime developer console
  gem 'pry' #TODO comment for uage
  gem 'pry-rails'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  # Coverage information
  gem 'simplecov', require: false
  # Stubbing external calls by blocking traffic with WebMock.disable_net_connect! or allow:
  #gem 'webmock'
end

group :production do
  # Use Postgresql in production
  gem 'pg'
  # Enables serving assets in production and setting your logger to standard out,
  # both of which are required to run a Rails application on a twelve-factor provider.
  # https://github.com/heroku/rails_12factor
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]