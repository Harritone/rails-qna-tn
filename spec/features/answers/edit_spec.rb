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

  scenario 'Unauthenticated user cannot edit answer', js: true do
    visit question_path(question)
    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
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

    scenario 'edits his answer with errors'
    scenario 'tries to edit other user\'s answer'
  end
end
