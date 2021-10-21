require 'rails_helper'

feature 'Authorized user can remove their own answers', %q(
  In order to remove anser
  As an authorized user
  I'd like to be able to remove my remove answer
  published by me
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  given(:another_user) { create(:user) }

  scenario 'User can delete their own answer' do
    login(user)
    visit questions_path
    click_link(question.title)
    expect(page).to have_content(answer.body)
    click_on('Remove answer')
    expect(page).to have_content('Answer was removed')
    expect(page).not_to have_content(answer.body)
  end

  scenario 'User cannot delete other\'s questions' do
    visit questions_path
    click_link(question.title)
    expect(page).not_to have_content('Remove answer')
  end
end

