require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }
  given(:another_question) { create(:question, user: another_user)}

  scenario 'Unauthenticated user cannot edit question', js: true do
    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'edits his question' do
      expect(page).to have_link 'Edit question'
      click_on 'Edit question'
      within '.question' do
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      expect(page).to have_link 'Edit question'
      click_on 'Edit question'
      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'edits a question with attached file' do
      click_on 'Edit question'
      within '.question' do
        fill_in 'Body', with: 'edited question body'
        attach_file 'File', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]
        click_on 'Save'
        expect(page).to have_link 'rails_helper'
        expect(page).to have_link 'spec_helper'
      end
    end

    scenario 'tries to edit other user\'s question' do
      visit question_path(another_question)
      expect(page).to_not have_link 'Edit question'
    end
  end
end
