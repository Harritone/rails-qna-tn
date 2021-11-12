class CreateForOauthService
  attr_reader :auth, :email

  def initialize(auth, email)
    @email = email
    @auth = auth
  end

  def call
    user = User.create(email: email, password: Devise.friendly_token[0, 20])
    return unless user.valid?

    user.authorizations.create(provider: auth[:provider], uid: auth[:uid].to_s)
    user
  end
end
