require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:auth_headers) do
    post '/auth/sign_in', params: { email: user.email, password: 'password' }
    {
      'access-token' => response.headers['access-token'],
      'client' => response.headers['client'],
      'uid' => user.email,
      'Content-Type' => 'application/json'
    }
  end

  describe 'POST /auth/sign_in' do
    it 'returns a token when credentials are valid' do
      post '/auth/sign_in', params: { email: user.email, password: 'password' }
      expect(response).to have_http_status(:ok)
      expect(response.headers['access-token']).to be_present
      expect(response.headers['client']).to be_present
    end

    it 'returns an error when credentials are invalid' do
      post '/auth/sign_in', params: { email: user.email, password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /protected_endpoint' do
    it 'allows access with valid credentials' do
      get '/protected_endpoint', headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'denies access with invalid credentials' do
      auth_headers['access-token'] = 'invalidtoken'
      get '/protected_endpoint', headers: auth_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
