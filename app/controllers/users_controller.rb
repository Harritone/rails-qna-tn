class UsersController < ApplicationController
  def email
    @user = User.new
  end

  def set_email
    @user = CreateForOauthService.new(session['oauth_data'], email_params[:email]).call
    if @user&.persisted?
      redirect_to root_path, notice: 'Your account was successfully created, please confirm your email.'
    else
      redirect_to root_path, alert: 'Something went wrong! Please try again later'
    end
    session['oauth_data'] = nil
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end
end
