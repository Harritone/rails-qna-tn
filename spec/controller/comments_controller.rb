require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:valid_params) do
      {
        comment: {
          content: 'new comment',
          commentable_type: question.class.name,
          commentable_id: question.id
        }
      }
    end

    context 'Authorized user' do
      before { login(user) }

      context 'with valid attributes' do
        subject { post :create, params: valid_params, format: :js }

        it 'should save comment to db' do
          expect{ subject }.to change{ question.comments.count }.by(1)
        end

        it 'should redirect to assotiated question' do
          subject
          expect(response).to render_template(:create)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) do
          {
            comment: {
              content: '',
              commentable_type: question.class.name,
              commentable_id: question.id
            }
          }
        end
        subject { post :create, params: invalid_params, format: :js }

        it 'should not save answer to db' do
          expect{subject}.not_to change{Comment.count}
        end

        it 'should re-render create' do
          subject
          expect(response).to render_template(:create)
        end
      end
    end

    context 'Anauthorized user' do
      it 'should not create comment' do
        expect{ post :create, params: valid_params, format: :js }
          .to_not change{ Comment.count }
      end
    end
  end
end