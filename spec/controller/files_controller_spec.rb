require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    context 'when question attachment' do
      subject { delete :destroy, params: { id: question.files.first, format: :js } }

      let(:question) { create(:question, :with_files) }
      let(:user) { create(:user) }

      before { login(user) }

      context 'when author deletes attachment to question' do
        let!(:question) { create(:question, :with_files, user: user) }

        it 'should remove file from question' do
          subject
          expect(question.reload.files).not_to be_attached
        end

        it 'should render destroy template' do
          subject
          expect(response).to render_template(:destroy)
        end
      end

      context 'when none author of question' do
        before { subject }

        it 'should not remove file from question' do
          expect(question.reload.files).to be_attached
        end

        it 'should render destroy template' do
          expect(response).to render_template(:destroy)
        end
      end
    end

    context 'when answer attachment' do
      subject { delete :destroy, params: { id: answer.files.first, format: :js } }

      let(:answer) { create(:answer, :with_files) }
      let(:user) { create(:user) }

      before { login(user) }

      context 'when author of the answer' do
        let!(:answer) { create(:answer, :with_files, user: user) }

        it 'should remove file from answer' do
          subject
          expect(answer.reload.files).not_to be_attached
        end

        it 'should render destroy template' do
          subject
          expect(response).to render_template(:destroy)
        end
      end

      context 'when none author of answer' do
        before { subject }

        it 'should not remove file from answer' do
          expect(answer.reload.files).to be_attached
        end

        it 'renders destroy template' do
          expect(response).to render_template :destroy
        end
      end
    end
  end
end
