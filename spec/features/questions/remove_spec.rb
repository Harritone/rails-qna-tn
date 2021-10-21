require 'rails_helper'

feature 'Authorized user can remove their own question', %q(
  In order to remove question
  As an authorized user
  I'd like to be able to remove my published question
) do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  scenario 'User can delete their own question' do
    login(user)
    visit questions_path
    click_link(question.title)
    expect(page).to have_content(question.body)
    click_on('Remove question')
    expect(page).to have_content('Question was removed')
    expect(page).not_to have_content(question.title)
  end

  scenario 'User cannot delete other\'s questions' do
    login(second_user)
    visit questions_path
    click_link(question.title)
    expect(page).not_to have_content('Remove question')
  end
end
