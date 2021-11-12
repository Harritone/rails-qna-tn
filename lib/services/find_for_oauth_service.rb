class FindForOauthService
  attr_reader :auth
  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email] 
    user = User.find_by(email: email)

    user ||= User.create!(email: email, password: Devise.friendly_token[0, 20])

    user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
    user
  end
end
