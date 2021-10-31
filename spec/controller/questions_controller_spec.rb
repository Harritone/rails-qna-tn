require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'should render index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'should render show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    subject { get :new }
    before { login(user) }

    it 'should render new view' do
      subject
      expect(response).to render_template(:new)
    end

    it 'should build nested links' do
      subject
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    it 'should render show view' do
      login(user)
      get :edit, params: { id: question}
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'With valid attributes' do
      let(:valid_params) { { question: attributes_for(:question) } }
      subject { post :create, params: valid_params }

      it 'should create question in db' do
        expect { subject }.to change { Question.count }.by(1)
      end

      it 'should redirects to show' do
        subject
        question = Question.first # as our db was empty before request
        expect(response).to redirect_to(question)
        expect(controller).to set_flash[:notice]
      end
    end

    context 'With invalid attributes' do
      let(:invalid_params) { { question: attributes_for(:question, :invalid) } }
      subject { post :create, params: invalid_params }

      it 'should not save question to db' do
        expect { subject }.to_not change { Question.count }
      end

      it 'should re-render new' do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      let(:valid_attributes) { { title: 'Updated title', body: 'Updated body' } }
      subject { patch :update, params: { id: question, question: valid_attributes }, format: :js }

      it 'should change question attributes' do
        subject
        question.reload
        expect(question.title).to eq(valid_attributes[:title])
        expect(question.body).to eq(valid_attributes[:body])
      end

      it 'should redirect to updated question' do
        subject
        expect(response).to redirect_to(question)
      end
    end

    context 'with invalid attributes' do
      subject { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'should not change question' do
        title = question.title
        body = question.body
        subject
        question.reload
        expect(question.title).to eq(title)
        expect(question.body).to eq(body)
      end
      it 'should re-render edit' do
        subject
        expect(response).to render_template(:update)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    subject { delete :destroy, params: { id: question } }
    before { login(user) }

    context 'when author delete his question' do
      it 'should delete the question' do
        question
        expect { subject }.to change { user.questions.count }.by(-1)
      end

      it 'should redirect to index' do
        subject
        expect(response).to redirect_to(questions_path)
        expect(controller).to set_flash[:notice]
      end
    end

    context 'when another user tries to delete the question' do
      before { login(another_user) }
      it 'should not delet the question' do
        question
        expect { subject }.not_to change { user.questions.count }
      end

      it 'should redirect ot index' do
        subject
        expect(response).to redirect_to(questions_path)
        expect(controller).to set_flash[:alert]
      end
    end
  end
end
