module ApplicationMailerHelper
  def email_with_name(user)
    %('#{user.name}' <#{user.email}>)
  end
end
