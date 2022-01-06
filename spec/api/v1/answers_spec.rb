require 'rails_helper'

describe 'Answers API', type: :request do
  let!(:user) { create :user }
  let!(:access_token) { create :access_token, resource_owner_id: user.id, scopes: 'answer' }
  let!(:question) { create :question, user_id: access_token.resource_owner_id }
  let!(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'unauthorized_requests' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, :with_files, question: question) }
      let(:answer) { answers.first }
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'should return 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return a list of answers' do
        expect(json[:answers].size).to eq 3
      end

      it 'should have public fields' do
        %i[id body created_at updated_at comments links].each do |attr|
          expect(json[:answers].first[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'should have file' do
        expect(json[:answers].first[:files].first).to include answer.files.blobs.first.filename.to_s
      end

      it 'should contain a user object' do
        expect(json[:answers].first[:user][:id]).to eq answer.user.id
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:answer) { create(:answer, :with_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    it_behaves_like 'unauthorized_requests' do
      let(:method) { :get }
    end

    context 'authorized' do
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end
      it 'should return 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return answer' do
        aggregate_failures do
          expect(json[:answer][:id]).to eq(answer.id)
          expect(json[:answer][:body]).to eq(answer.body)
        end
      end

      it 'should have a list of comments' do
        expect(json[:answer][:comments].size).to eq 3
      end

      it 'should have links' do
        expect(json[:answer][:links].size).to eq 3
      end

      it 'should have file' do
        expect(json[:answer][:files].first).to include answer.files.blobs.first.filename.to_s
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'unauthorized_requests' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization': "Bearer #{access_token.token}" } }

      context 'with valid attributes' do
        subject { post api_path, params: { answer: attributes_for(:answer) }, headers: headers, as: :json }

        it 'should return 201' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'should create answer' do
          expect{ subject }.to change(Answer, :count).by(1)
        end

        it 'should render propper json' do
          subject
          answer = Answer.last
          expect(json[:answer][:id]).to eq(answer.id)
          expect(json[:answer][:body]).to eq(answer.body)
          expect(json[:answer][:question_id]).to eq(question.id)
        end
      end

      context 'with invalid attributes' do
        let(:attr) { { "body": nil } }
        subject { post api_path, params: { answer: attr}, headers: headers, as: :json }

        it 'should return 422' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return error json' do
          subject
          expect(json[:errors]).to include("Body can't be blank")
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:question_id/answers/:id' do
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'unauthorized_requests' do
      let(:method) { :put }
    end
    context 'authorized' do
      let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization': "Bearer #{access_token.token}" } }
      let(:attributes) do
        {
          "body" => "new body answer"
        }
      end

      context 'with valid attributes' do
        subject { put api_path, params: { answer: attributes }, headers: headers, as: :json }
        it 'should return 200 status' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'should update answer' do
          subject
          answer.reload
          expect(answer.body).to eq "new body answer"
        end

        it 'should render json with updated answer' do
          subject
          answer.reload
          expect(json[:answer][:id]).to eq(answer.id)
          expect(json[:answer][:body]).to eq(answer.body)
          expect(json[:answer][:question_id]).to eq(question.id)
        end
      end

      context 'with invalid attributes' do
        let(:attr) { { "body": nil } }
        subject { put api_path, params: { answer: attr}, headers: headers, as: :json }

        it 'should return 422' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return error json' do
          subject
          expect(json[:errors]).to include("Body can't be blank")
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:question_id/answers/:id' do
    let(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

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
        answer
        expect{ subject }.to change(Answer, :count).by(-1)
      end
    end
  end
end
