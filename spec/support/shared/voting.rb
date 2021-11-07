require 'rails_helper'

shared_examples 'voting' do
  describe 'Unauthenticated user' do
    scenario "cannot change resource rating by voting" do
      visit question_path(resource_voting_page)
      expect(page).to_not have_selector('.vote-up')
      expect(page).to_not have_selector('.vote-down')
      expect(page).to_not have_link 're-vote'
    end
  end

  describe 'Authenticated author' do
    scenario 'tries to change resource rating by voting' do
      login(author)
      visit question_path(resource_voting_page)

      within resource_rating_class do
        expect(page).to_not have_selector('.vote-up')
        expect(page).to_not have_selector('.vote-down')
        expect(page).to_not have_link 're-vote'
      end
    end
  end

  describe 'Authenticated user', js: true do
    before do
      login(other_user)
      visit question_path(resource_voting_page)
    end

    scenario 'votes up for a resource' do
      within resource_rating_class do
        find('.vote-up').click

        expect(find('.total-votes')).to have_content '1'
        expect(page).to_not have_selector('.vote-up')
        expect(page).to_not have_selector('.vote-down')
        expect(page).to have_link 're-vote'
      end
    end

    scenario 'votes down for a resource' do
      within resource_rating_class do
        find('.vote-down').click

        expect(find('.total-votes')).to have_content '-1'
        expect(page).to_not have_selector('.vote-up')
        expect(page).to_not have_selector('.vote-down')
        expect(page).to have_link 're-vote'
      end
    end

    scenario 'cancels vote for a resource' do
      within resource_rating_class do
        find('.vote-down').click

        expect(page).to_not have_selector('.vote-up')
        expect(page).to_not have_selector('.vote-down')
        expect(page).to have_link 're-vote'

        find('.re-vote').click

        expect(find('.total-votes')).to have_content '0'
        expect(page).to_not have_link 're-vote'
        expect(page).to have_selector('.vote-up')
        expect(page).to have_selector('.vote-down')
      end
    end
  end
end
