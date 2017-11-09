# sport-portal

A Ruby on Rails app to manage sport matches

Branch | Travis CI  | Code Coverage | Code Analysis | Heroku Deploy | Errbit
------ | ---------- | ------------- | ------------- | ------------- | ------
master  |[![Build Status](https://travis-ci.org/hpi-swt2/sport-portal.svg?branch=master)](https://travis-ci.org/hpi-swt2/sport-portal) | [![Coverage Status](https://coveralls.io/repos/github/hpi-swt2/sport-portal/badge.svg?branch=master)](https://coveralls.io/github/hpi-swt2/sport-portal?branch=master) | [![Maintainability](https://api.codeclimate.com/v1/badges/dc7597d1a5e076edb3e4/maintainability)](https://codeclimate.com/github/hpi-swt2/sport-portal/maintainability) | [![Heroku](https://heroku-badge.herokuapp.com/?app=sport-portal)](http://sport-portal.herokuapp.com/) [[link]](http://sport-portal.herokuapp.com/) | [[link]](https://swt2-errbit-2017.herokuapp.com/apps/5a030ed1d901a0000620325e) |
dev  |[![Build Status](https://travis-ci.org/hpi-swt2/sport-portal.svg?branch=dev)](https://travis-ci.org/hpi-swt2/sport-portal/branches) | [![Coverage Status](https://coveralls.io/repos/github/hpi-swt2/sport-portal/badge.svg?branch=dev)](https://coveralls.io/github/hpi-swt2/sport-portal?branch=dev) |   | [![Heroku](https://heroku-badge.herokuapp.com/?app=sport-portal-dev)](https://sport-portal-dev.herokuapp.com/) [[link]](https://sport-portal-dev.herokuapp.com/) | [[link]](https://swt2-errbit-2017.herokuapp.com/apps/5a031be36caee90014ce8531) |

When all tests succeed on Travis CI, the application is deployed to Heroku. Click the badges for detailed info. <br>
Errors that occur while using the deployed master branch on Heroku are logged to the [Errbit](http://swt2-errbit-2017.herokuapp.com/) error catcher, you can sign in with your Github account.

## Local Setup

* Clone this repository
* `cat .ruby-version && echo $(ruby --version)` See if locally installed ruby version matches the one specified in the `.ruby_version` file. 
* _If the ruby version is different:_ Install the required version using [rbenv](https://github.com/rbenv/rbenv#installation) (recommended) or [RVM](https://rvm.io/rvm/install)
* `gem install bundler` Install [bundler](http://bundler.io/) for managing Ruby gems 
* `bundle install` Install the required Ruby gem dependencies defined in the project's [Gemfile](http://bundler.io/gemfile.html)
* `rake db:create db:migrate db:seed` Setup database, run migrations, seed the database with defaults
* `rspec` Run all the tests (using the [RSpec](http://rspec.info/) test framework)
* `rails s` Start the Rails development server (By default runs on `localhost:3000`)

## Setup using Vagrant (Virtual Machine)

If you want to use a VM to setup the project (e.g. when on Windows), we recommend [Vagrant](https://www.vagrantup.com/).
Please keep in mind that this method may lead to a loss in performance, due to the added abstraction layer.

```
vagrant up # download and provision the VM
vagrant ssh # login using SSH
cd hpi-swt2
gem install bundler #  Install bundler for managing Ruby gems
bundle install # install dependencies using bundler
bundle exec rails s -b 0 # start the rails server
# the -b part is necessary since the app is running in a VM and would
# otherwise drop the requests coming from the host OS
```

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
