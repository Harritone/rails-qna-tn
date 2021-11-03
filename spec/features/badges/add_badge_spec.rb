require 'rails_helper'

feature 'User can assign badge as a reward to question', %q{
  In order to reward the best answer to my question
  As an author of the question
  I'd like to be able to assign badge as a reward
} do
  given(:user) { create(:user) }
  given(:badge) { create(:badge) }

  background do
    login(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User assigns badge when asks question' do
    fill_in 'Badge name', with: 'For the best answer ever'
    attach_file 'Image', Rails.root.join('public/badges/badge.jpg')
    click_on 'Ask'
    expect(page).to have_content 'For the best answer ever'
  end

  scenario 'User assigns badge with errors' do
    fill_in 'Badge name', with: 'For the best answer ever'
    attach_file 'Image', Rails.root.join('spec/spec_helper.rb')
    click_on 'Ask'
    expect(page).to have_content 'Badge image has an invalid content type'
  end
end
