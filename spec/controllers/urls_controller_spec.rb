require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let(:valid_url) { 'https://example.com' }
  let(:invalid_url) { 'invalid-url' }
  let(:url) { Url.create!(original_url: valid_url) }

  describe 'POST #encode' do
    context 'when the URL is valid' do
      it 'creates a new URL and returns a short URL' do
        post :encode, params: { original_url: valid_url }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['short_url']).to include(request.base_url)
      end
    end

    context 'when the URL is invalid' do
      it 'returns an error with status unprocessable entity' do
        post :encode, params: { original_url: invalid_url }

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Invalid URL format')
      end
    end

    context 'when the URL is blank' do
      it 'returns an error with status bad request' do
        post :encode, params: { original_url: '' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Original URL is required')
      end
    end
  end

  describe 'POST #decode' do
    context 'when the short code exists' do
      it 'returns the original URL' do
        post :decode, params: { short_url: url.short_code }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['original_url']).to eq(valid_url)
      end
    end

    context 'when the short code does not exist' do
      it 'returns an error with status not found' do
        post :decode, params: { short_url: 'nonexistentcode' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Short code not found')
      end
    end

    context 'when the short code is blank' do
      it 'returns an error with status bad request' do
        post :decode, params: { short_code: '' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Short URL is required')
      end
    end
  end
end
