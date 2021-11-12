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
    let(:service) { double('FindForOauthService') }

    it 'should call FindForAuthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call).and_return(user)
      User.find_for_oauth(auth)
    end
  end
end
