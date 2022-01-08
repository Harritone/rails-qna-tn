require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  it { should belong_to(:best_answer).optional(true) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(255) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it 'should have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#normal_answers' do
    it 'should return answers without best answer' do
      question = build(:question)
      answers = create_list(:answer, 3, question: question)
      best_answer = create(:answer, question: question)
      question.best_answer = best_answer
      question.save
      expect(question.normal_answers).to_not include(best_answer)
      expect(question.normal_answers).to include(answers.first)
      expect(question.normal_answers).to include(answers.second)
      expect(question.normal_answers).to include(answers.last)
    end

    it 'should return all answers if there is no best answer' do
      question = create(:question)
      answers = create_list(:answer, 3, question: question)
      expect(question.normal_answers).to eq(answers)
    end
  end

  describe 'subscribe_author' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'creates subscription' do
      expect { question.save! }.to change(Subscription, :count).by(1)
    end

    it 'subscribes author' do
      question.save!
      subscription = Subscription.first
      expect(subscription.subscribable_type).to eq('Question')
      expect(subscription.subscribable_id).to eq(question.id)
      expect(subscription.user).to eq(user)
    end
  end
end
