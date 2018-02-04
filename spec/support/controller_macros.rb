module ControllerMacros
  def mock_devise
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
end
