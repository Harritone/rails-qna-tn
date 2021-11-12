require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe 'GET #github' do
    let(:user) { create(:user) }
    let(:oauth_data) { { 'provider': 'github', 'uid': 123 } }

    it 'should find user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end
      it 'should login user if exists' do
        expect(subject.current_user).to be user
      end

      it 'should redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'should redirect to root if user does not exist' do
        expect(response).to redirect_to root_path
      end

      it 'should not login user if does not exist' do
        expect(subject.current_user).to be_nil
      end
    end
  end
end
