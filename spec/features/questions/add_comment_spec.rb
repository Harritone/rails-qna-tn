require 'rails_helper'

feature 'User can post comment to question', %q{
  In order to comment question
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'multiple sessions' do
    scenario 'question appears on another user browser', js: true do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
        # expect(page).to have_link('Post comment')
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        # expect(page).to_not have_link('Post comment')
      end

      Capybara.using_session('user') do
       within('#new_comment') do
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

