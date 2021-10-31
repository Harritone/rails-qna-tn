require 'rails_helper'

feature 'User can add answer to qeustions', %q(
  In order to help other users published questions
  As authenticated user I'd like to post an answer
  to a particular question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'publish answer' do
      fill_in 'Your answer', with: 'My awesome answer!'
      click_on 'Publish'
      expect(current_path).to eq(question_path(question))
      within '.answers' do
        expect(page).to have_content 'My awesome answer!'
      end
    end

    scenario 'publish invalid answer' do
      click_on 'Publish'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'publish an answer with attached file' do
      fill_in 'Your answer', with: 'My awesome answer!'
      attach_file 'File', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]
      click_on 'Publish'
      expect(page).to have_link 'rails_helper'
      expect(page).to have_link 'spec_helper'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to publish answer' do
      visit question_path(question)
      fill_in 'Your answer', with: 'My awesome answer!'
      click_on 'Publish'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
