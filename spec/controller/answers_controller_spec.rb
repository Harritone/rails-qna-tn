require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_params) { {answer: attributes_for(:answer), question_id: question.id } }
      subject { post :create, params: valid_params, format: :js }

      it 'should save answer to db' do
        expect{subject}.to change{question.answers.count}.by(1)
      end

      it 'should redirect to assotiated question' do
        subject
        expect(response).to render_template(:create)
        # expect(controller).to set_flash[:notice]
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { {answer: attributes_for(:answer, :invalid), question_id: question.id } }
      subject { post :create, params: invalid_params, format: :js }

      it 'should not save answer to db' do
        expect{subject}.not_to change{Answer.count}
      end

      it 'should re-render new' do
        subject
        expect(response).to render_template(:create)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, user: user, question: question) }
    subject { delete :destroy, params: { id: answer.id } }

    context 'when author tries to delete his answer' do
      it 'should delete answer' do
        answer
        expect{ subject }.to change{user.answers.count}.by(-1)
      end

      it 'should redirect to related question' do
        subject
        expect(response).to redirect_to(question_path(question))
        expect(controller).to set_flash[:alert]
      end
    end

    context 'when another user tries to delete not his anwer' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'should not delete answer' do
        answer
        expect{ subject }.not_to change{user.answers.count}
      end

      it 'should redirect to related question' do
        subject
        expect(response).to redirect_to(question_path(question))
        expect(controller).to set_flash[:alert]
      end
    end
  end
end
