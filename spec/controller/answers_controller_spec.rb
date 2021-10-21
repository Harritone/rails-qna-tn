require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  before { login(user) }

  context 'with valid attributes' do
    let(:valid_params) { {answer: attributes_for(:answer), question_id: question.id } }
    subject { post :create, params: valid_params }

    it 'should save answer to db' do
      expect{subject}.to change{question.answers.count}.by(1)
    end

    it 'should redirect to assotiated question' do
      subject
      expect(response).to redirect_to(question)
    end
  end

  context 'with invalid attributes' do
    let(:invalid_params) { {answer: attributes_for(:answer, :invalid), question_id: question.id } }
    subject { post :create, params: invalid_params }

    it 'should not save answer to db' do
      expect{subject}.not_to change{Answer.count}
    end

    it 'should re-render new' do
      subject
      expect(response).to render_template('questions/show')
    end
  end
end
