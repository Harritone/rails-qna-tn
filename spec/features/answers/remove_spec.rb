require 'rails_helper'

feature 'Authorized user can remove their own answers', %q(
  In order to remove answer
  As an authorized user
  I'd like to be able to remove my remove answer
  published by me
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'User can delete their own answer', js: :true do
    login(user)
    visit questions_path
    click_link question.title
    expect(page).to have_content answer.body
    click_on 'Remove answer'
    expect(page).not_to have_content answer.body
  end

  scenario 'Authorized user connot delete other\s answers', js: true do
    login(another_user)
    visit questions_path
    click_link question.title
    expect(page).not_to have_link 'Remove answer'
  end

  scenario 'Unauthorized user cannot delete answers', js: true do
    visit questions_path
    click_link question.title
    expect(page).not_to have_link 'Remove answer'
  end
end

