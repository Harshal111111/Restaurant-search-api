# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UserFavouritesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'POST #create' do
    let(:valid_place_id) { 'valid_place_id' }
    let(:invalid_place_id) { 'invalid_place_id' }

    context 'when place_id is valid' do
      before do
        allow(controller).to receive(:is_valid_place_id).with(valid_place_id).and_return(true)
      end

      it 'creates a new user_favourite and returns success' do
        post :create, params: { google_place_id: valid_place_id }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be_truthy
        expect(json_response['messages']).to eq('Successfully Marked as favourite')
      end
    end

    context 'when place_id is invalid' do
      before do
        allow(controller).to receive(:is_valid_place_id).with(invalid_place_id).and_return(false)
      end

      it 'returns bad request with error message' do
        post :create, params: { google_place_id: invalid_place_id }
        expect(response).to have_http_status(:bad_request)

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be_falsy
        expect(json_response['messages']).to eq('Place id is not valid')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:valid_place_id) { 'valid_place_id' }
    let(:invalid_place_id) { 'invalid_place_id' }

    context 'when place_id is valid and user_favourite exists' do
      before do
        allow(controller).to receive(:is_valid_place_id).with(valid_place_id).and_return(true)
        user.user_favourites.create(google_place_id: valid_place_id)
      end

      it 'destroys the user_favourite and returns success' do
        delete :destroy, params: { google_place_id: valid_place_id }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be_truthy
        expect(json_response['messages']).to eq('Successfully removed from favourites')
      end
    end

    context 'when place_id is valid but user_favourite does not exist' do
      before do
        allow(controller).to receive(:is_valid_place_id).with(valid_place_id).and_return(true)
      end

      it 'returns not found with error message' do
        delete :destroy, params: { google_place_id: valid_place_id }
        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be_falsy
        expect(json_response['messages']).to eq('Record not found')
      end
    end

    context 'when place_id is invalid' do
      before do
        allow(controller).to receive(:is_valid_place_id).with(invalid_place_id).and_return(false)
      end

      it 'returns bad request with error message' do
        delete :destroy, params: { google_place_id: invalid_place_id }
        expect(response).to have_http_status(:bad_request)

        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be_falsy
        expect(json_response['messages']).to eq('Place id is not valid')
      end
    end
  end
end
