require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/Harritone/170e91c1ce800c34417bc4ede3926f2a' }

  scenario 'User adds link when asks question', js: true do
    login(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My awesome answer!'
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Publish'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
