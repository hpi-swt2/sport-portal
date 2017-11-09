Airbrake.configure do |config|
  config.host = 'https://swt2-errbit-2017.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = '0cb97a3d4465c438daa8e8bd5471937b'
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
