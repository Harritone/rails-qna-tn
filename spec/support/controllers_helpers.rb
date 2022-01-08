module ControllersHelpers
  def login(user)
    @request.env['devise.mappin'] = Devise.mappings[:user]
    # user.confirm
    sign_in(user)
  end
end
