require 'rails_helper'

shared_examples_for 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe '#vote_count' do
    it 'should return sum of votes results' do
      votable = create(described_class.to_s.underscore.to_sym)
      create_list(:vote, 5, votable: votable, result: -1)
      expect(votable.votes_count).to eq(-5)
    end
  end
end
