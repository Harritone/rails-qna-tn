require 'rails_helper'

feature 'User can see qeustion and answers to related question', %q(
  In order to find answers to 
  particular question
  As unauthrized user
  I'd like to be able to see them on the question page
) do
  scenario 'Unauthenticated user browses questions' do
    question = create(:question)
    answers = create_list(:answer, 3, question: question)
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end

