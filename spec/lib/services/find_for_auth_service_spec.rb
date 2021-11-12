require 'rails_helper'

RSpec.describe FindForOauthService do
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123') }
  let!(:user) { create(:user) }
  subject { described_class.new(auth).call }

  context 'user already has authorization' do
    it 'should return user' do
      user.authorizations.create(provider: 'facebook', uid: '123123')
      expect(subject).to eq user
    end
  end

  context 'user has no authorization' do
    context 'user exists in db' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: user.email }) }

      it 'should not create new user' do
        expect{ subject }.to_not change(User, :count)
      end

      it 'should create authorisation for user' do
        expect{ subject }.to change(Authorization, :count).by(1)
      end

      it 'should create authorization with provider and uid' do
        authorization = subject.authorizations.first
        expect(authorization.uid).to eq auth.uid
        expect(authorization.provider).to eq auth.provider
      end

      it 'should return user' do
        expect(subject).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: 'new@user.com' }) }

      it 'should create new user' do
        expect{ subject }.to change(User, :count).by(1)
      end

      it 'should return new user' do
        expect(subject).to be_a(User)
      end

      it 'should fill user email' do
        user = subject
        expect(user.email).to eq auth.info.email
      end

      it 'should create authorization for user' do
        user = subject
        expect(user.authorizations).to_not be_empty
      end

      it 'should create authorization with provider and uid' do
        authorization = subject.authorizations.first
        expect(authorization.uid).to eq auth.uid
        expect(authorization.provider).to eq auth.provider
      end
    end
  end
end
