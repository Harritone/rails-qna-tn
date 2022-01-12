require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #search' do
    let(:search)               { Search }
    let(:question)             { create :question }
    let(:find_question)        { post :search, params: { query: question.body } }
    let(:find_question_scoped) { post :search, params: { query: question.body, scope: 'Question' } }

    it 'finds the result with scope' do
      expect(search).to receive(:call).with(question.body, 'Question').and_return [question]
      find_question_scoped
      expect(assigns(:result).first).to be_a(Question)
    end

    it 'finds the result without scope' do
      expect(search).to receive(:call).with(question.body, nil).and_return [question]
      find_question
      expect(assigns(:result).first).to be_a(Question)
    end
  end
end
