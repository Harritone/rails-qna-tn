require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) { { 'CONTENT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/profiles' do
    it_behaves_like 'unauthorized_requests' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end
    context 'authorized' do
      let!(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }
      let!(:profiles) { create_list(:user, 3) }

      before do
        get '/api/v1/profiles/', params: { access_token: access_token.token }, headers: headers
      end

      it 'should return 200 status' do
        expect(response.status).to eq 200
      end

      it 'should return a list of users without logged in user' do
        expect(json[:users].size).to eq(3)
        profiles.each do |user|
          expect(json[:users]).to include(JSON.parse(user.to_json).deep_symbolize_keys)
        end
        expect(json[:users]).to_not include(JSON.parse(me.to_json).deep_symbolize_keys)
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'unauthorized_requests' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'should return 200 status' do
        expect(response.status).to eq 200
      end

      it 'should return all public fields' do
        %i[id email admin created_at updated_at].each do |attr|
          expect(json[:user][attr]).to eq me.send(attr).as_json
        end
      end

      it 'should not return private fields' do
        %i[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
