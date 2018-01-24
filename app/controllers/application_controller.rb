class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render file: "#{Rails.root}/public/403.html", status: 403, layout: false
    else
      render file: "#{Rails.root}/public/401.html", status: 401, layout: false
    end
  end

  #Redirect to user dashboard after successful login
  def after_sign_in_path_for(resource)
    dashboard_user_path(resource)
  end

  private
    def set_locale
      I18n.locale = :de
    end
end
