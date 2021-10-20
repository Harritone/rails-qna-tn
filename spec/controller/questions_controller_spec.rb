require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'should populate an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'should render index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'should assign the requested question to @questions' do
      expect(assigns(:question)).to eq(question)
    end

    it 'should render show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'should assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'should render new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'should assign the requested question to @questions' do
      expect(assigns(:question)).to eq(question)
    end

    it 'should render show view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'With valid attributes' do
      let(:valid_params) { { question: attributes_for(:question) } }
      subject { post :create, params: valid_params }

      it 'should create question in db' do
        expect { subject }.to change { Question.count }.by(1)
      end

      it 'should redirects to show' do
        subject
        expect(response).to redirect_to(assigns(:question))
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
    context 'with valid attributes' do
      let(:valid_attributes) { { title: 'Updated title', body: 'Updated body' } }
      subject { patch :update, params: { id: question, question: valid_attributes } }

      it 'should assign the requested question to @question' do
        subject
        expect(assigns(:question)).to eq(question)
      end

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
      subject { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
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
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: question } }
    it 'should delete the question' do
      question
      expect { subject }.to change { Question.count }.by(-1)
    end

    it 'should redirect to index' do
      subject
      expect(response).to redirect_to(questions_path)
    end
  end
end
