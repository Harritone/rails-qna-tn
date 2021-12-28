require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) { { 'CONTENT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    context 'unauthorized' do
      it 'should return 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers, as: :json
        expect(response.status).to eq 401
      end

      it 'should return 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: 'invalid_token' }, headers: headers, as: :json
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'should return 200 status' do
        expect(response.status).to eq 200
      end

      it 'should return all public fields' do
        # json = JSON.parse(response.body).deep_symbolize_keys
        %i[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'should not return private fields' do
        # json = JSON.parse(response.body).deep_symbolize_keys
        %i[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end

      end
    end
  end
end
