require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create :user }
  background { login user }

  scenario 'log out' do
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end
end
