require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_params) { {answer: attributes_for(:answer), question_id: question.id } }
      subject { post :create, params: valid_params, format: :js }

      it 'should save answer to db' do
        expect{ subject }.to change{ question.answers.count }.by(1)
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

      it 'should re-render create' do
        subject
        expect(response).to render_template(:create)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer, user: user, question: question) }
    subject { delete :destroy, params: { id: answer.id }, format: :js }

    context 'when author tries to delete his answer' do
      it 'should delete answer' do
        answer
        expect{ subject }.to change{user.answers.count}.by(-1)
      end

      it 'should redirect to related question' do
        subject
        expect(response).to render_template(:destroy)
      end
    end

    context 'when another user tries to delete not his answer' do
      before { login(another_user) }

      it 'should not delete answer' do
        answer
        expect{ subject }.not_to change{user.answers.count}
      end

      it 'should render create template' do
        subject
        expect(response).to render_template(:destroy)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, user: user, question: question) }
    subject { patch :update, params: { id: answer.id, answer: { body: 'Edited answer' } }, format: :js }

    context 'when author tries to update his answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'should update answer' do
          subject
          answer.reload
          expect(answer.body).to eq('Edited answer')
        end

        it 'should render update view' do
          subject
          expect(response).to render_template(:update)
        end
      end

      context 'with invalid attributes' do
        let(:subject) { patch :update, params: { id: answer.id, answer: { body: nil } }, format: :js }

        it 'should not update answer' do
          expect{ subject }.to_not change(answer, :body)
        end

        it 'should re-render update' do
          subject
          expect(response).to render_template(:update)
        end
      end
    end

    context 'when non-author tries to delete answer' do
      before { login(another_user) }

      it 'should not update answer' do
        answer.reload
        expect { subject }.to_not change(answer, :body)
        expect(answer.body).to_not eq('Edited answer')
      end
    end
  end
end
