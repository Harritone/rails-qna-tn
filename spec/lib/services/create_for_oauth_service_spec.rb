require 'rails_helper'

RSpec.describe CreateForOauthService do
  let!(:auth) { {'provider': 'facebook', 'uid': '123123'} }
  let(:email) { 'new@mail.com' }
  let!(:user) { create(:user) }
  subject { described_class.new(auth, email).call }

  it 'should create user' do
    expect{ subject }.to change(User, :count).by(1)
  end

  it 'should return nil when invalid params provided' do
    expect(described_class.new(auth, '').call).to be_nil
  end

  it 'should return user' do
    expect(subject).to be_a(User)
  end

  it 'should create authorization for user' do
    expect(subject.authorizations).not_to be_empty
  end

  it 'should create authorization with provider and uid' do
    authorization = subject.authorizations.first
    expect(authorization.uid).to eq auth[:uid].to_s
    expect(authorization.provider).to eq auth[:provider].to_s
  end
end
