module ControllerMacros
  def mock_devise
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end
  end
end
