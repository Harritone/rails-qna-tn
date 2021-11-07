shared_examples 'voted' do
  describe 'authorized user' do
    let(:expected_json) do
      {
        id: votable.id,
        resource: votable.class.name.underscore,
        votes: votable.votes_count
      }
    end

    context 'PUT #vote_up' do
      before { login(another_user) }
      subject { put :vote_up, params: { id: votable }, format: :js }

      it 'should set votable' do
        subject
        expect(assigns(:votable)).to eq votable
      end

      it 'should change the vote when voted down' do
        votable.votes.create(user: another_user, result: -1)
        expect { subject }.to change { votable.votes_count }.by(2)
      end

      it 'should create new vote when not voted' do
        expect { subject }.to change { votable.votes_count }.by(1)
      end

      it 'should render json with results' do
        subject
        expect(response.content_type).to match 'json'
        expect(json).to eq expected_json
      end
    end

    context 'PUT #vote_down' do
      before { login(another_user) }
      subject { put :vote_down, params: { id: votable }, format: :js }

      it 'should set votable' do
        subject
        expect(assigns(:votable)).to eq votable
      end

      it 'should change vote when voted up' do
        votable.votes.create(user: another_user, result: 1)
        expect { subject }.to change { votable.votes_count }.by(-2)
      end

      it 'should create vote wheb not voted' do
        expect { subject }.to change { votable.votes_count }.by(-1)
      end

      it 'should render json with results' do
        subject
        expect(response.content_type).to match 'json'
        expect(json).to eq expected_json
      end
    end

    context 'PUT #revote' do
      before { login(another_user) }
      subject { put :revote, params: { id: votable }, format: :js }

      it 'should set votable' do
        subject
        expect(assigns(:votable)).to eq votable
      end

      it 'should reset vote when voted down' do
        put :vote_down, params: { id: votable }, format: :js
        expect{ subject }.to change { votable.votes_count }.by(1)
      end

      it 'should reset vote when voted up' do
        put :vote_up, params: { id: votable }, format: :js
        expect{ subject }.to change { votable.votes_count }.by(-1)
      end

      it 'should render json with results' do
        subject
        expect(response.content_type).to match 'json'
        expect(json).to eq expected_json
      end
    end
  end

  describe 'unauthorized user' do
    context 'PUT #vote_up' do
      it 'should return status forbidden' do
        put :vote_up, params: { id: votable }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'PUT #vote_down' do
      it 'should return status forbidden' do
        put :vote_down, params: { id: votable }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'PUT #revote' do
      it 'should return status forbidden' do
        put :revote, params: { id: votable }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'author' do
    before { login(user) }

    context 'PUT #vote_up' do
      it 'should return status forbidden' do
        put :vote_up, params: { id: votable }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'PUT #vote_down' do
      it 'should return status forbidden' do
        put :vote_down, params: { id: votable }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'PUT #revote' do
      it 'should return status forbidden' do
        put :revote, params: { id: votable }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
