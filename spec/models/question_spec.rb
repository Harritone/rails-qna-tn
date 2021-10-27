require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:best_answer).optional(true) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(255) }
  it { should validate_length_of(:body).is_at_least(10) }

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

    it 'should return all answers if there is no best answers' do
      question = create(:question)
      answers = create_list(:answer, 3, question: question)
      expect(question.normal_answers).to eq(answers)
    end
  end
end
