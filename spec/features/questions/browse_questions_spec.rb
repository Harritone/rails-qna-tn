require 'rails_helper'

feature 'User can browse qeustions', %q(
  In order to find question
  As unauthrized user
  I'd like to be able to browse questions
) do
  scenario 'Unauthenticated user browses questions' do
    questions = create_list(:question, 3)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end
