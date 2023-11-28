# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RestaurantsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET #index' do
    let(:search_place) { 'Indore' }
    let(:restaurants) { [{ name: 'Restaurant 1', address: 'Address 1', photo_urls: ['abc.jpg'], favourite: true }] }

    context 'when the search is successful' do
      before do
        allow(RestaurantSearchService).to receive(:call).with(search_place, user).and_return(restaurants)
      end

      it 'returns a JSON response with the list of restaurants' do
        get :index, params: { restaurant: { search_place: search_place } }, session: { user_id: user.id }
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response['restaurants']).to contain_exactly(
          a_hash_including('name' => 'Restaurant 1', 'address' => 'Address 1', 'photo_urls' => ['abc.jpg'],
                           'favourite' => true)
        )
      end
    end

    context 'when the search fails' do
      before do
        allow(RestaurantSearchService).to receive(:call).with(search_place, user).and_return([])
      end

      it 'returns an empty JSON response' do
        get :index, params: { restaurant: { search_place: search_place } }, session: { user_id: user.id }
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response['restaurants']).to be_empty
      end
    end

    context 'when an exception occurs in RestaurantSearchService' do
      it 'returns an internal server error' do
        allow(RestaurantSearchService).to receive(:call).and_raise(StandardError, 'Something went wrong')

        get :index, params: { restaurant: { search_place: search_place } }, session: { user_id: user.id }

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Something went wrong' })
      end
    end
  end
end
