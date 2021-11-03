require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:another_user) { create(:user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:google_url) { 'https://google.com' }

  scenario 'Unauthenticated user cannot edit answer', js: true do
    visit question_path(question)
    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      login(user)
      visit question_path(question)
      expect(page).to have_link 'Edit'
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      login(user)
      visit question_path(question)
      expect(page).to have_link 'Edit'
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'tries to edit other user\'s answer' do
      login(another_user)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits an answer with attached file' do
      login(user)
      visit question_path(question)
      expect(page).to have_link 'Edit'
      click_on 'Edit'
      within '.answers' do
        attach_file 'File', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]
        click_on 'Save'
        expect(page).to have_link 'rails_helper'
        expect(page).to have_link 'spec_helper'
      end
    end

    scenario 'adds new links when edit', js: true do
      login(user)
      visit question_path(question)
      expect(page).to have_link 'Edit'
      click_on 'Edit'
      within '.answers' do
        click_on 'Add link'
        fill_in 'Link name', with: 'My link'
        fill_in 'URL', with: google_url
      end

      click_on 'Save'

      expect(page).to have_link 'My link', href: google_url
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'cannot edit answers' do
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
