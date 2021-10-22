require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'should return true if an enetety has user_id with id of given user' do
      expect(user.author_of?(question)).to equal(true)
    end

    it 'should return false if an enetety has user_id without id of given user' do
      expect(another_user.author_of?(question)).to equal(false)
    end

    it 'should return falsy value if an entety has no user_id' do
      expect(user.author_of?(another_user)).to be_falsey
    end
  end
end
