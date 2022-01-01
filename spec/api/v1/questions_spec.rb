require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let!(:access_token) { create :access_token, resource_owner_id: user.id }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'unauthorized_requests' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json[:questions].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'should return 200 status' do
        expect(response.status).to eq 200
      end

      it 'should list of questions' do
        expect(json[:questions].size).to eq 2
      end

      it 'should return public fields' do
        %i[id title body].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'should contain user object' do
        expect(question_response[:user][:id]).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response[:answers] }

        it 'should return list of answers' do
          expect(answer_response.size).to eq 3
        end

        it 'should return all public fields' do
          %i[id body created_at updated_at].each do |attr|
            expect(answer_response.first[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'unauthorized_requests' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:user) { create :user }
      let!(:question) { create(:question, :with_files, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      before do
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
      end

      it 'should return 200 status' do
        expect(response.status).to eq 200
      end

      it 'should return all public fields' do
        %i[id title body].each do |attr|
          expect(json[:question][attr]).to eq question.send(attr).as_json
        end
      end

      it 'should return comments' do
        json[:question][:comments].each_with_index do |comment, i|
          expect(comment[:content]).to eq comments[i].content.as_json
          expect(comment[:id]).to eq comments[i].id.as_json
          expect(comment[:commentable_id]).to eq comments[i].commentable_id.as_json
          expect(comment[:commentable_type]).to eq comments[i].commentable_type.as_json
        end
      end

      it 'should return links' do
        json[:question][:links].each_with_index do |link, i|
          expect(link[:id]).to eq links[i].id.as_json
          expect(link[:url]).to eq links[i].url.as_json
          expect(link[:linkable_type]).to eq links[i].linkable_type.as_json
          expect(link[:linkable_id]).to eq links[i].linkable_id.as_json
        end
      end

      it 'should return files' do
        expect(json[:question][:files].first).to include question.files.blobs.first.filename.to_s
      end
    end
  end

  describe "POST /api/v1/questions" do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'unauthorized_requests' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization': "Bearer #{access_token.token}" } }
      context 'valid attributes' do
        subject { post api_path, params: { question: attributes_for(:question) }, headers: headers, as: :json }

        it 'should return 201' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should create question' do
          expect{subject}.to change(Question, :count).by(1)
        end

        it 'should return question' do
          subject
          question = Question.last
          expect(json[:question][:title]).to eq question.title
          expect(json[:question][:body]).to eq question.body
          expect(json[:question][:user][:id]).to eq user.id
        end
      end

      context 'with invalid attributes' do
        let(:attributes) {{"body" => nil, "title" => nil}}
        subject { post api_path, params: { question: attributes }, headers: headers, as: :json }

        it 'should return 422' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return error' do
          subject
          expect(json[:errors]).to include("Title can't be blank")
          expect(json[:errors]).to include("Body can't be blank")
        end
      end
    end
  end

  describe "PUT /api/v1/questions/:id" do
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'unauthorized_requests' do
      let(:method) { :put }
    end

    context 'authorized' do
      let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization': "Bearer #{access_token.token}" } }
      context 'valid attributes' do
        let(:attributes) {{"body": "updated body question"}}
        subject { put api_path, params: { question: attributes }, headers: headers, as: :json }

        it 'should return 201' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'should update question' do
          subject
          question.reload
          expect(question.body).to eq("updated body question")
        end

        it 'should return question' do
          subject
          question.reload
          expect(json[:question][:title]).to eq question.title
          expect(json[:question][:body]).to eq question.body
          expect(json[:question][:user][:id]).to eq user.id
        end
      end

      context 'with invalid attributes' do
        let(:attributes) {{"body" => nil, "title" => nil}}
        subject { put api_path, params: { question: attributes }, headers: headers, as: :json }

        it 'should return 422' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return error' do
          subject
          expect(json[:errors]).to include("Title can't be blank")
          expect(json[:errors]).to include("Body can't be blank")
        end
      end
    end
  end

  describe "DELETE /api/v1/questions/:id" do
    let (:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'unauthorized_requests' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization': "Bearer #{access_token.token}" } }
      subject { delete api_path, headers: headers }

      it 'should return no content' do
        subject
        expect(response.body).to be_blank
      end

      it 'should delete answer' do
        question
        expect{ subject }.to change(Question, :count).by(-1)
      end
    end
  end
end
