require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'Get #email' do
    before { get :email }

    it 'should assign new user to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'should render email view' do
      expect(response).to render_template :email
    end
  end

  describe 'Post #set_email' do
    let!(:oauth_data) { { 'provider' => 'vkontakte', 'uid' => 123123 } }

    before { session[:oauth_data] = oauth_data }

    it 'should create a new user' do
      pp attributes_for(:user)
      expect{ post :set_email, params: { user: { email: 'new@mail.com' } } }.to change(User, :count).by(1)
    end

    it 'redirects to root' do
      post :set_email, params: { user: attributes_for(:user) }
      expect(response).to redirect_to root_path
    end

    it 'should set session auth_data to nil' do
      post :set_email, params: { user: attributes_for(:user) }
      expect(session[:oauth_data]).to be_nil
    end

    context 'Some errors occured' do
      it 'should redirect to root' do
        post :set_email, params: { user: { email: '' } }
        expect(response).to redirect_to(root_path)
      end

      it 'should set alert' do
        post :set_email, params: { user: { email: '' } }
        expect(controller).to set_flash[:alert]
      end

    end

  end
end
