require 'rails_helper'

feature 'Author of the question can mark answer as best', %q{
  As an author of the question
  In order to choose best answer
  I'd like to mark one of the answers on
  my question as best
} do
  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 10, user: another_user, question: question) }

  describe 'Author of the question', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'marks as best one of the answers' do
      within all('.actions').first do
        click_on 'Best it!'
      end

      expect(page).to have_content 'Best Answer'
      expect(first('.answers')).to have_content answers.first.body
    end

    scenario 'marks another one as best' do
      within all('.actions').first do
        click_on 'Best it!'
      end

      within all('.actions').last do
        click_on 'Best it!'
      end

      expect(page).to have_content 'Best Answer'
      expect(first('.answers')).to have_content answers.last.body
    end
  end

  scenario 'Not author of the question cannot mark as best one of the answers' do
    login(another_user)
    visit question_path(question)
    expect(page).not_to have_link 'Best it!'
  end

  scenario 'Non authenticated user connot mark as best one of the answers' do
    visit question_path(question)
    expect(page).not_to have_link 'Best it!'
  end
end
