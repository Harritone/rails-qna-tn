require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:google_url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/Harritone/170e91c1ce800c34417bc4ede3926f2a' }

  background do
    login(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'My awesome answer!'
  end

  scenario 'User adds link when publish answer', js: true do
    fill_in 'Link name', with: 'My link'
    fill_in 'URL', with: google_url

    click_on 'Publish'

    within '.answers' do
      expect(page).to have_link 'My link', href: google_url
    end
  end

  scenario 'User adds invalid link when publish answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: 'Http/gisthub'
    click_on 'Publish'

    expect(page).to have_content 'is not a valid HTTP URL'
  end

  scenario 'User adds link to gist when publish answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url
    click_on 'Publish'
    visit current_path

    expect(page).to have_content 'hosted with ❤ by GitHub'
  end
end
