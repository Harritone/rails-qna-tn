require 'rails_helper'

feature 'User can post comment to answer', %q{
  In order to comment answer
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }

  context 'multiple sessions' do
    scenario 'comment appears on another user browser', js: true do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
       within('.answers') do
         fill_in 'Comment', with: 'My awesome comment'
         click_on 'Post comment'
       end
       expect(page).to have_content 'My awesome comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My awesome comment'
      end
    end
  end
end


