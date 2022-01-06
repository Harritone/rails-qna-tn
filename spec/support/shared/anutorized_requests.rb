shared_examples_for 'unauthorized_requests' do
  context 'unauthorized' do
    it 'should return 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers, as: :json)
      expect(response.status).to eq 401
    end

    it 'should return 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: 'invalid_token' }, headers: headers, as: :json)
      expect(response.status).to eq 401
    end
  end

end
