class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #Redirect to user dashboard after successfull login
  def after_sign_in_path_for(resource)
    dashboard_user_path(resource)
  end
  def createEvents
  end
end
