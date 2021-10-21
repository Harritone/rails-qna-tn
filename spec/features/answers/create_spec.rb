require 'rails_helper'

feature 'User can add answer to qeustions', %q(
  In order to help other users published questions
  As authenticated user I'd like to post an answer
  to a particular question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end
    scenario 'publish answer' do
      fill_in('Your answer', with: 'My awesome answer!')
      click_on('Publish')
      expect(page).to have_content('Answer was published.')
      expect(page).to have_content('My awesome answer!')
    end

    scenario 'publish invalid answer' do
      click_on('Publish')
      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to publish answer' do
      visit question_path(question)
      fill_in('Your answer', with: 'My awesome answer!')
      click_on('Publish')
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
