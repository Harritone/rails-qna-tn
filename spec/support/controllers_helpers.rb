module ControllersHelpers
  def login(user)
    @request.env['devise.mappin'] = Devise.mappings[:user]
    sign_in(user)
  end
end
