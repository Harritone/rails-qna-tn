require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }
  # given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user cannot edit question', js: true do
    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      login(user)
      visit question_path(question)
      expect(page).to have_link 'Edit question'
      click_on 'Edit question'
      within '.question' do
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'
        # expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      login(user)
      visit question_path(question)
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

    scenario 'tries to edit other user\'s question' do
      login(another_user)
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end
end
