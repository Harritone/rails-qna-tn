require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:badges).dependent(:nullify) }
  it { should have_many(:authorizations).dependent(:destroy) }

  let!(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_user) { create(:user) }

  describe '#author_of?' do

    it 'should return true if an enetety has user_id with id of given user' do
      expect(user).to be_author_of(question)
    end

    it 'should return false if an enetety has user_id without id of given user' do
      expect(another_user.author_of?(question)).to equal(false)
    end

    it 'should return falsy value if an entety has no user_id' do
      expect(user.author_of?(another_user)).to be_falsey
    end
  end

  describe '#voted_for?' do
    it 'should return false if not voted' do
      expect(user.voted_for?(question)).to be_falsy
    end

    it 'should return true if voted' do
      create(:vote, user: another_user, votable: question)
      expect(another_user.voted_for?(question)).to be_truthy
    end
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123') }

    context 'user already has authorization' do
      it 'should return user' do
        user.authorizations.create(provider: 'facebook', uid: '123123')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user exists in db' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: user.email }) }

        it 'should not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'should create authorisation for user' do
          expect{ User.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
        end

        it 'should create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.uid).to eq auth.uid
          expect(authorization.provider).to eq auth.provider
        end

        it 'should return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: 'new@user.com' }) }

        it 'should create new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'should return new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'should fill user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'should create authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'should create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.uid).to eq auth.uid
          expect(authorization.provider).to eq auth.provider
        end
      end
    end
  end
end
