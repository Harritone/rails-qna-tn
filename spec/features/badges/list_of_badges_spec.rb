require 'rails_helper'

feature 'User can view a list of his badges', "
  As un authenticated user
  I'd like to be able to view a list of my rewarded badges for my answers
" do
  given(:user) { create(:user, :with_badges) }

  scenario 'User views a list of questions' do
    login(user)
    visit badges_path

    expect(page).to have_content 'My badges'

    user.badges.each do |badge|
      expect(page).to have_content badge.question.title
      expect(page).to have_content badge.name
      expect(page).to have_css 'img'
    end
  end
end
