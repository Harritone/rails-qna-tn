require 'rails_helper'

feature 'User can browse qeustions', %q(
  In order to find question
  As unauthrized user
  I'd like to be able to browse questions
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }
  background do
    visit questions_path
  end

  scenario 'Unauthenticated user browses questions' do
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Authenticated user can browse questions' do
    login(user)
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
