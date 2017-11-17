# sport-portal

A Ruby on Rails app to manage sport matches

[![Waffle.io - Columns and their card count](https://badge.waffle.io/hpi-swt2/sport-portal.svg?columns=all)](https://waffle.io/hpi-swt2/sport-portal) 

Branch | Travis CI  | Code Coverage | Code Analysis | Heroku Deploy | Errbit
------ | ---------- | ------------- | ------------- | ------------- | ------
dev (default) |[![Build Status](https://travis-ci.org/hpi-swt2/sport-portal.svg?branch=dev)](https://travis-ci.org/hpi-swt2/sport-portal) | [![Coverage Status](https://coveralls.io/repos/github/hpi-swt2/sport-portal/badge.svg?branch=dev)](https://coveralls.io/github/hpi-swt2/sport-portal?branch=dev) | [![Maintainability](https://api.codeclimate.com/v1/badges/dc7597d1a5e076edb3e4/maintainability)](https://codeclimate.com/github/hpi-swt2/sport-portal/maintainability) | [![Heroku](https://heroku-badge.herokuapp.com/?app=sport-portal-dev)](https://sport-portal-dev.herokuapp.com/) [[link]](https://sport-portal-dev.herokuapp.com/) | [[link]](https://swt2-errbit-2017.herokuapp.com/apps/5a031be36caee90014ce8531) |
master  |[![Build Status](https://travis-ci.org/hpi-swt2/sport-portal.svg?branch=master)](https://travis-ci.org/hpi-swt2/sport-portal/branches) | [![Coverage Status](https://coveralls.io/repos/github/hpi-swt2/sport-portal/badge.svg?branch=master)](https://coveralls.io/github/hpi-swt2/sport-portal?branch=master) |   | [![Heroku](https://heroku-badge.herokuapp.com/?app=sport-portal)](http://sport-portal.herokuapp.com/) [[link]](http://sport-portal.herokuapp.com/) | [[link]](https://swt2-errbit-2017.herokuapp.com/apps/5a030ed1d901a0000620325e) |


When all tests succeed on Travis CI, the application is deployed to Heroku. Click the badges for detailed info. <br>
Errors that occur while using the deployed master branch on Heroku are logged to the [Errbit](http://swt2-errbit-2017.herokuapp.com/) error catcher, you can sign in with your Github account.

## Setup

You can setup the project either locally, i.e. directly on your system, or using a VM (e.g. when on Windows). Please keep in mind that using a VM may lead to a loss in performance, due to the added abstraction layer.

### Local

* Clone this repository
* `cat .ruby-version && echo $(ruby --version)` See if locally installed ruby version matches the one specified in the `.ruby_version` file.
* _If the ruby version is different:_ Install the required version using [rbenv](https://github.com/rbenv/rbenv#installation) (recommended) or [RVM](https://rvm.io/rvm/install)
* `gem install bundler` Install [bundler](http://bundler.io/) for managing Ruby gems
* `bundle install` Install the required Ruby gem dependencies defined in the [Gemfile](http://bundler.io/gemfile.html)
(if there are any errors, ensure that the following packages are installed: `libpq-dev`, `libsqlite3-dev`, `g++`, if you are on MacOS you run `bundle install --without production` to skip the `libpq-dev` dependency)
* `rake db:create db:migrate db:seed` Setup database, run migrations, seed the database with defaults
* `rspec` Run all the tests (using the [RSpec](http://rspec.info/) test framework)
* `rails s` Start the Rails development server (runs on `localhost:3000` by default)

### Using Vagrant (Virtual Machine)

* Install a Virtual Machine provider, we recommend [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install [Vagrant](https://www.vagrantup.com/downloads.html) which makes setting up the VM easier. The Vagrantfile in this repo provides the configuration for the VM
* Clone this repository and change to the created folder
* `vagrant up` Download and provision the VM
* `vagrant ssh` SSH into the VM
* `cd hpi-swt2` Change into the repo folder, mounted from your local machine
* `gem install bundler` Install bundler for managing Ruby gems (it is itself a gem)
* `bundle install` Install the required Ruby gem dependencies defined in the [Gemfile](http://bundler.io/gemfile.html)
* `bundle exec rails s -b 0` Start the rails server, don't drop non-local requests (-b)
* Open `localhost:3000` on the host machine, port 3000 (the default server port) is forwarded from the VM
* `vagrant suspend` issued from the host, suspends the VM (`halt` shuts down)

## Employed Libraries

All libraries employed in this project are listed in the project's `Gemfile`. Some potentially useful ones for the future are commented out. The most important ones currently used are:

* `devise` ([docs](https://github.com/plataformatec/devise)) Authentication solution for Rails, responsible for session management, logging users in and out, etc.
* `omniauth` ([docs](https://github.com/omniauth/omniauth)) Provides standardized multi-provider authentication, could be useful for openID authentication
* `cancancan` ([docs](https://github.com/CanCanCommunity/cancancan)) Authorization library which restricts what resources a given user is allowed to access. All permissions are defined in an 'Ability' file (`app/models/ability.rb`) and do not have to be duplicated.
* `factory_bot_rails` ([docs](https://github.com/thoughtbot/factory_bot_rails)) Fixture replacement, build objects using factories
* `jquery-rails` ([docs](https://github.com/rails/jquery-rails)) Use jQuery as the JavaScript library
* `twitter-bootstrap-rails` ([docs](https://github.com/seyhunak/twitter-bootstrap-rails)) Use Bootstrap CSS toolkit
* `turbolinks` ([docs](https://github.com/turbolinks/turbolinks)) Turbolinks speeds up page loads using AJAX. No server-side cooperation necessary. It automatically fetches the page, swaps in its `<body>` and merges its `<head>`, without the cost of a full page load
* `has_scope` ([docs](https://github.com/plataformatec/has_scope)) Map incoming controller parameters to named scopes in resources

## Important Development Commands

* `bundle exec <command>` Run command within the context of the current gemset
* `rspec spec/controller/expenses_controller_spec.rb` Specify a folder or test file to run
* `bundle exec annotate` Add a comment summarizing the current schema to the top of files
* `bundle exec rubocop` Run static code analysis for code smells based on `.rubocop.yml` config
* `rails c` Run the Rails console
* `rails c --sandbox` Test out some code without changing any data
* `rails g migration DoSomething` Create migration _db/migrate/*_DoSomething.rb_.
* `rails dbconsole` Starts the CLI of the database you're using
* `rake routes` Show all the routes (and their names) of the application
* `rails assets:precompile` Precompile the assets in app/assets to public/assets
* `rake about` Show stats on current Rails installation, including version numbers
* `rspec --profile` examine how much time individual tests take
* Put `<%= console %>` anywhere in a view to render an interactive console session (provided by 'web-console' gem)
* Put `byebug` anywhere in ruby code to start a debugging session (provided by 'byebug' gem)
