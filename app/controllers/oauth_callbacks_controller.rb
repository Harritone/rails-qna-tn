class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    handle_auth 'Github'
  end

  private

  def handle_auth(kind)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    elsif !@user && !auth.nil?
      session['oauth_data'] = auth.except('extra')
      redirect_to email_path, alert: "You need to provide with email to proceed signing in process with #{kind}"
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
