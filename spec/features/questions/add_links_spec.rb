require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an author of the question
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Harritone/170e91c1ce800c34417bc4ede3926f2a' }
  given(:google_url) { 'https://google.com' }

  background do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds regular link when asks question' do
    fill_in 'Link name', with: 'My link'
    fill_in 'URL', with: google_url

    click_on 'Ask'

    expect(page).to have_link 'My link', href: google_url
  end

  scenario 'User adds invalid link when asks question', js: true do
    fill_in 'Link name', with: 'My link'
    fill_in 'URL', with: 'Http//gisthub'

    click_on 'Ask'

    expect(page).to have_content 'is not a valid HTTP URL'
  end

  scenario 'User adds link to gist when asks question', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url
    click_on 'Ask'

    expect(page).to have_content 'hosted with ❤ by GitHub'
  end
end
