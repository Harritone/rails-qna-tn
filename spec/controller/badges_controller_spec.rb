require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  describe 'GET #index' do
    let(:user_with_badges) { create(:user, :with_badges) }
    it 'should show users badges' do
      login(user_with_badges)
      get :index
      expect(assigns(:badges)).to eq(user_with_badges.badges)
    end
  end
end
