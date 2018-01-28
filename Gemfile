source 'https://rubygems.org'

ruby '2.4.0'

# The Ruby on Rails web development framework
# everything needed to create database-backed web applications according to the Model-View-Controller (MVC) pattern
# https://github.com/rails/rails
gem 'rails', '~> 5.1.4'
# Default server for Rails, built for concurrency
# https://github.com/puma/puma
gem 'puma'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Evaluate JavaScript from within Ruby, e.g. for the Rails Asset Pipeline
# https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Turbolinks speeds up page loads using AJAX. No server-side cooperation necessary.
# Automatically fetches the page, swaps in its <body>,
# and merges its <head>, without incurring the cost of a full page load
# https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Compressor for JavaScript assets
# https://github.com/lautis/uglifier/
gem 'uglifier', '>= 1.3.0'
# Flexible authentication solution for Rails
# https://github.com/plataformatec/devise
gem 'devise'
# Bootstrap-themed views for devise
# https://github.com/hisea/devise-bootstrap-views/
gem 'devise-bootstrap-views'
# Useful for openID authentication
# Library that provides standardizes multi-provider authentication
# https://github.com/omniauth/omniauth
gem 'omniauth'
# Support for OpenID when authenticating
gem 'omniauth-openid'
# Provide current CA certificates for validating omniauth provider identity
gem 'certified'
# Authorization library which restricts what resources a given user is allowed to access
# All permissions are defined in a 'Ability' and not duplicated across controllers, views, and database queries.
# https://github.com/CanCanCommunity/cancancan
gem 'cancancan'
# Fixture replacement, build objects using factories
# Also Used in production in seeds.rb
# https://github.com/thoughtbot/factory_bot_rails
gem 'factory_bot_rails'
# Bootstrap CSS toolkit for Rails Asset Pipeline
# https://github.com/seyhunak/twitter-bootstrap-rails
gem 'twitter-bootstrap-rails'
# Map incoming controller parameters to named scopes in your resources
# https://github.com/plataformatec/has_scope
gem 'has_scope'
# for Windows users
# gem 'nokogiri', '1.6.7.rc3', platforms: [:mswin, :mingw, :x64_mingw]
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Used for file uploaded
gem 'shrine', '~>2.8.0'

# Packages the jQuery UI assets (JavaScripts, stylesheets, and images) for the Rails asset pipeline
# https://github.com/jquery-ui-rails/jquery-ui-rails
gem 'jquery-ui-rails'

# Use Bootstrap Tooltips
# https://github.com/brandonhilkert/bootstrap-tooltip-rails
# gem 'bootstrap-tooltip-rails'

# Use Bootstrap datepicker
# https://github.com/Nerian/bootstrap-datepicker-rails
gem 'bootstrap-datepicker-rails'

# Gem to easily split DateTimes
# https://github.com/shekibobo/time_splitter
gem "time_splitter"

# Package Select2 dropdown replacement featuring autocomplete
# https://github.com/argerim/select2-rails
# gem 'select2-rails'

# Build JSON APIs with ease.
# https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

# Documentation generator
# https://github.com/zzak/sdoc/
# gem 'sdoc', '~> 0.4.0', group: :doc

# to parse date parameters from ui
# https://github.com/clemens/delocalize
# gem 'delocalize'

# Gem for many customizable scalable vector icons
# https://github.com/bokmann/font-awesome-rails
gem 'font-awesome-rails'

# Gem for nested fields inside forms
# https://github.com/lailsonbm/awesome_nested_fields
gem 'awesome_nested_fields'
# Use the materializecss-library https://github.com/mkhairi/materialize-sass
# A modern, responsive front-end-framework based on Material Design
gem 'materialize-sass'

gem 'faker'

group :development, :test do
  # Testing framework for Rails
  # https://github.com/rspec/rspec-rails
  gem 'rspec-rails'
  # For assigns and assert_template in controller tests
  # https://github.com/rails/rails-controller-testing
  gem 'rails-controller-testing'
  # Behaviour driven development library with a DSL close to natural language
  # https://cucumber.io
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  # Acceptance test framework for web applications
  # https://github.com/teamcapybara/capybara
  gem 'capybara'
  # Mailer convenience methods
  gem 'capybara-email'
  # Manage translation and localization with static analysis, for Ruby i18n
  # https://github.com/glebm/i18n-tasks
  gem 'i18n-tasks'
  # Code coverage for Ruby
  # https://github.com/colszowka/simplecov
  gem 'simplecov', '~> 0.14.0', require: false

  # Hosted code coverage on coveralls.io
  # https://docs.coveralls.io/ruby-on-rails
  gem 'coveralls', require: false
  # Collection cardinality matchers, extracted from rspec-expectations
  # https://github.com/rspec/rspec-collection_matchers
  gem 'rspec-collection_matchers'
  # Ruby bindings for the SQLite3 embedded database
  # https://github.com/sparklemotion/sqlite3-ruby
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  # https://github.com/rails/web-console
  gem 'web-console'
  # feature rich debugger for Ruby
  # https://github.com/deivid-rodriguez/byebug
  # Start debugging by putting 'byebug' anywhere in the code
  # http://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-byebug-gem
  gem 'byebug'
  # Static code analysis for Ruby
  # https://github.com/bbatsov/rubocop
  gem 'rubocop', require: false
  # Add a comment summarizing the current schema to the top of files
  # run with 'bundle exec annotate'
  # https://github.com/ctran/annotate_models
  gem 'annotate'
  # Rails application preloader
  # https://github.com/rails/spring
  gem 'spring'
  # https://github.com/jonleighton/spring-watcher-listen
  gem 'spring-watcher-listen'
  # Replace standard Rails error page with more useful error page
  # https://github.com/charliesome/better_errors
  gem 'better_errors'
  # for use in better_errors
  # https://github.com/banister/binding_of_caller
  gem 'binding_of_caller'
  # Alternative to the standard IRB shell for Ruby
  # Start an interactive REPL session with 'binding.pry' anywhere in the code
  # https://github.com/pry/pry
  gem 'pry'
  # Causes 'rails console' to open the pry console
  # https://github.com/rweng/pry-rails
  gem 'pry-rails'
  # Causes 'rescue rspec' to open a debugging session on the first failing test
  # https://github.com/ConradIrwin/pry-rescue
  gem 'pry-rescue'
end

group :production do
  # Ruby interface to the PostgreSQL RDBMS
  # https://github.com/ged/ruby-pg
  gem 'pg', '~> 0.21.0'
  # Exception tracking in production, report to Errbit
  # https://github.com/airbrake/airbrake
  # Errbit requires airbrake 5.0
  gem 'airbrake', '~> 5.0'

  # S3 upload should only be used in production
  gem 'aws-sdk-s3', '~> 1.2'

end
