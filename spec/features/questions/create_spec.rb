require 'rails_helper'

feature 'Registered user can create question', %q(
  In order to get answer from a community
  As an authorized user
  I'd like to be able to ask the question
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on('Ask')
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      # attach_file 'File', Rails.root.join('spec/rails_helper.rb')
      attach_file 'File', [Rails.root.join('spec', 'rails_helper.rb'), Rails.root.join('spec', 'spec_helper.rb')]
      click_on 'Ask'
      expect(page).to have_link 'rails_helper'
      expect(page).to have_link 'spec_helper'
    end
  end

  fcontext 'multiple sessions' do
    scenario 'question appears on another user browser', js: true do
      Capybara.using_session('user') do
        login(user)
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'
        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
