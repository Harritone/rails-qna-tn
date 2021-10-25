require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
" do
  background { visit new_user_registration_path }

  describe 'successfull registration' do
    background do
      fill_in 'Email',                 with: 'test@gmail.com'
      fill_in 'Password',	             with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
    end

    scenario 'redirects to root path' do
      expect(page).to have_current_path(root_path)
    end

    scenario 'has welcome message' do
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  describe 'registration failed' do
    given(:user) { create :user, email: 'test@gmail.com' }

    background { fill_in 'Email', with: user.email }

    scenario 'with incorrect password' do
      fill_in 'Password',	             with: '12345'
      fill_in 'Password confirmation', with: '12345'
      click_on 'Sign up'

      expect(page).to have_content 'Password is too short'
    end

    scenario 'with email already exists' do
      fill_in 'Password',	             with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
