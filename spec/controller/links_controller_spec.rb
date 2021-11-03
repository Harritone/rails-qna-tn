
require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context 'when question link' do
      let(:question) { create(:question, :with_links, user: user) }
      let!(:link) { question.links.first }

      subject { delete :destroy, params: { id: question.links.first, format: :js } }

      context 'when author deletes attachment to question' do
        before { login(user) }

        it 'should remove link from question' do
          subject
          expect(question.reload.links).not_to include(link)
        end

        it 'should render destroy template' do
          subject
          expect(response).to render_template(:destroy)
        end
      end

      context 'when none author of question' do
        before { login(another_user) }

        it 'should not remove links from question' do
          subject
          expect(question.reload.links).to include(link)
        end

        it 'should render destroy template' do
          subject
          expect(response).to render_template(:destroy)
        end
      end
    end

    context 'when answer link' do
      subject { delete :destroy, params: { id: answer.links.first, format: :js } }

      let(:answer) { create(:answer, :with_links, user: user) }
      let!(:link) { answer.links.first }

      context 'when author of the answer' do
        before { login(user) }

        it 'should remove file from answer' do
          subject
          expect(answer.reload.links).not_to include(link)
        end

        it 'should render destroy template' do
          subject
          expect(response).to render_template(:destroy)
        end
      end

      context 'when none author of answer' do
        before { login(another_user) }

        it 'should not remove file from answer' do
          subject
          expect(answer.reload.links).to include(link)
        end

        it 'renders destroy template' do
          subject
          expect(response).to render_template :destroy
        end
      end
    end
  end
end
