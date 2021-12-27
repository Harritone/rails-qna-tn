require 'rails_helper'

describe Ability do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }

    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)        { create :user }
    let(:second_user) { create :user }

    let(:question)        { create :question, user: user }
    let(:second_question) { create :question, user: second_user }

    it { is_expected.to     be_able_to :read, :all }
    it { is_expected.not_to be_able_to :manage, :all }

    it { is_expected.to be_able_to :create, Question }

    it { is_expected.to     be_able_to :update, create(:question, user: user), user: user }
    it { is_expected.not_to be_able_to :update, create(:question, user: second_user), user: user }

    context 'when answer' do
      let(:answer)        { create :answer, question: question, user: user }
      let(:second_answer) { create :answer, question: second_question, user: second_user }

      it { is_expected.to     be_able_to :create, Answer }
      it { is_expected.to     be_able_to :update, answer, user: user }
      it { is_expected.not_to be_able_to :update, second_answer, user: user }
    end

    context 'when comment' do
      let(:comment)        { create :comment, commentable: question, user: user }
      let(:second_comment) { create :comment, commentable: question, user: second_user }

      it { is_expected.to     be_able_to :create, Comment }
      it { is_expected.to     be_able_to :update, comment, user: user }
      it { is_expected.not_to be_able_to :update, second_comment, user: user }
    end
  end
end
