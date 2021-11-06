require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :votable }
  it { is_expected.to validate_presence_of :result }
  it { is_expected.to validate_inclusion_of(:result).in_array([-1, 0, 1]) }
  it { is_expected.to validate_inclusion_of(:votable_type).in_array(%w[Question Answer]) }

  describe 'uniqueness of user scoped to votable' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, question: question) }
    let(:question) { create(:question) }
    let!(:voted) { create(:vote, votable: answer, user: user) }
    let!(:voted) { create(:vote, votable: question, user: user) }

    it { should validate_uniqueness_of(:user).scoped_to([:votable_id, :votable_type]) }
  end

  let(:vote) { create(:vote) }
  describe '#up' do
    it 'should set result to 1' do
      vote.up
      expect(vote.result).to eq 1
    end
  end

  describe '#down' do
    it 'should set result to -1' do
      vote.down
      expect(vote.result).to eq(-1)
    end
  end

  describe '#reset_vote' do
    it 'should set result to 0' do
      vote.up
      expect(vote.result).to eq 1

      vote.reset_vote
      expect(vote.result).to eq(0)
    end
  end
end
