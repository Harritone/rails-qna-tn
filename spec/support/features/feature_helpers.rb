module FeatureHelpers
  def login(user, options = {})
    visit new_user_session_path
    fill_in 'Email', with: (user&.email || options[:email])
    fill_in 'Password', with: (user&.password || options[:password])
    click_on 'Log in'
  end
end
