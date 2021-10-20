require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  context 'with valid attributes' do
    let(:valid_params) { {answer: attributes_for(:answer), question_id: question.id } }
    subject { post :create, params: valid_params }
    
    it 'should save answer to db' do
      expect{subject}.to change{Answer.count}.by(1)
    end
    
    it 'should redirect to assotiated question' do
      subject
      expect(response).to redirect_to(question)
    end
  end

  context 'with invalid attributes' do
    let(:invalid_params) { {answer: attributes_for(:answer, :invalid), question_id: question.id } }
    subject { post :create, params: invalid_params }

    it 'should not save anser to db' do
      expect{subject}.not_to change{question.answers.count}
    end

    it 'should re-render new' do
     subject
     expect(response).to render_template(:new)
    end
  end
end
