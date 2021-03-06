require 'rails_helper'

feature 'Authorized user can remove their own question', %q(
  In order to remove question
  As an authorized user
  I'd like to be able to remove my published question
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_files, user_id: user.id) }
  given(:another_user) { create(:user) }
  given(:question_with_links) { create(:question, :with_links, user: user) }

  scenario 'User can delete their own question', js: true do
    login(user)
    visit questions_path
    click_link question.title
    expect(page).to have_content question.body
    expect(page).to have_link 'Remove question'
    click_on 'Remove question'
    expect(page).to have_content 'Question was removed'
    expect(page).not_to have_content question.title
  end

  scenario 'Author can delete attached files', js: true do
    login(user)
    visit question_path(question)

    within all('.file').last do
      expect(page).to have_link 'rails_helper.rb'
      click_on 'Delete file'
    end

    expect(page).to_not have_link 'rails_helper.rb'
  end

  scenario 'Author can delete links', js: true do
    login(user)
    visit question_path(question_with_links)

    within all('.link').first do
      expect(page).to have_link question_with_links.links.first.name
      page.first('.remove-link').click
      # click_on 'Delete link', match: :first
    end

    expect(page).to_not have_link question_with_links.links.first.name
  end

  scenario 'User cannot delete other\'s questions' do
    login another_user
    visit questions_path(question)
    click_link question.title
    expect(page).not_to have_link 'Remove question'
  end

  scenario 'Guests cannot delete questions' do
    visit questions_path(question)
    click_link question.title
    expect(page).not_to have_link 'Remove question'
  end
end
