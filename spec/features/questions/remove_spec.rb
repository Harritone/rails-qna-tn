require 'rails_helper'

feature 'Authorized user can remove their own question', %q(
  In order to remove question
  As an authorized user
  I'd like to be able to remove my published question
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given(:another_user) { create(:user) }

  scenario 'User can delete their own question' do
    login(user)
    visit questions_path
    click_link question.title
    expect(page).to have_content question.body
    click_on 'Remove question'
    expect(page).to have_content 'Question was removed'
    expect(page).not_to have_content question.title
  end

  scenario 'User cannot delete other\'s questions' do
    login another_user
    visit questions_path
    click_link question.title
    expect(page).not_to have_link 'Remove question'
  end

  scenario 'Guests cannot delete questions' do
    visit questions_path
    click_link question.title
    expect(page).not_to have_link 'Remove question'
  end
end
