release: bundle exec rake db:schema:load DISABLE_DATABASE_ENVIRONMENT_CHECK=1 && bundle exec rake db:seed DISABLE_DATABASE_ENVIRONMENT_CHECK=1
web: bundle exec puma -C config/puma.rb