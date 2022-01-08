# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create :user }
  let!(:second_user) { create :user }
  let!(:question) { create :question }

  subject(:create_subscription) do
    post :create, params: { subscribable_type: question.class.to_s, subscribable_id: question.id }, format: :js
  end

  before { login user }

  describe '#POST create' do
    it 'creates a new subscription' do
      expect { create_subscription }.to change(Subscription, :count).by 1
    end
  end

  describe '#DELETE destroy' do
    subject(:delete_subscription) do
      delete :destroy, params: { id: subscription }, format: :js
    end

    context 'author of subscription' do
      let!(:subscription) { create :subscription, user: user, subscribable: question }

      it 'deletes subscription' do
        expect { delete_subscription }.to change(Subscription, :count).by(-1)
      end
    end

    context 'not author' do
      let!(:subscription) { create(:subscription, user: second_user, subscribable: question) }

      it 'non-author can not delete subscription' do
        pp user
        pp subscription
        expect { delete_subscription }.to_not change(Subscription, :count)
      end
    end
  end
end
