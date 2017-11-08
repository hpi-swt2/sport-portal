Airbrake.configure do |config|
  config.host = 'https://swt2-errbit-2017.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = '06ad9d54ff00ce2d8a0afcbd5289ed12'
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
