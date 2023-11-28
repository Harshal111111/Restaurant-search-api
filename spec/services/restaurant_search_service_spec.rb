# frozen_string_literal: true

require 'rails_helper'
RSpec.describe RestaurantSearchService, type: :service do
  let(:google_api_key) { ENV['GOOGLE_API_KEY'] }
  let(:place) { 'some_place' }
  let(:current_user) { FactoryBot.create(:user) }

  describe '#call' do
    it 'calls search_restaurants with the provided place' do
      service = RestaurantSearchService.new(place, current_user)
      allow(service).to receive(:search_restaurants)
      service.call
      expect(service).to have_received(:search_restaurants)
    end
  end

  describe '#search_restaurants' do
    it 'returns an array of restaurant details' do
      allow(HTTParty).to receive(:get).and_return(
        double(success?: true, parsed_response: { 'results' => [] })
      )

      service = RestaurantSearchService.new(place, current_user)
      results = service.send(:search_restaurants, place, current_user)
      expect(results).to be_an(Array)
    end

    context 'when the API call is successful' do
      it 'maps the results to a list of restaurant details' do
        allow(HTTParty).to receive(:get).and_return(
          double(success?: true, parsed_response: { 'results' => [{ 'name' => 'Restaurant A', 'formatted_address' => '123 Main St', 'place_id' => '123' }] })
        )

        allow(UserFavourite).to receive(:find_by).and_return(nil)

        service = RestaurantSearchService.new(place, current_user)
        results = service.send(:search_restaurants, place, current_user)

        expect(results).to eq([{
                                name: 'Restaurant A',
                                address: '123 Main St',
                                photo_urls: [],
                                favourite: false,
                                place_id: '123'
                              }])
      end

      it 'includes favorite flag based on UserFavourite' do
        allow(HTTParty).to receive(:get).and_return(
          double(success?: true, parsed_response: { 'results' => [{ 'name' => 'Restaurant A', 'formatted_address' => '123 Main St', 'place_id' => '123' }] })
        )

        allow(UserFavourite).to receive(:find_by).with(google_place_id: '123').and_return(double(present?: true))

        service = RestaurantSearchService.new(place, current_user)
        results = service.send(:search_restaurants, place, current_user)

        expect(results).to eq([{
                                name: 'Restaurant A',
                                address: '123 Main St',
                                photo_urls: [],
                                favourite: false,
                                place_id: '123'
                              }])
      end
    end

    context 'when the API call is not successful' do
      it 'returns an empty array' do
        allow(HTTParty).to receive(:get).and_return(
          double(success?: false, parsed_response: {})
        )

        service = RestaurantSearchService.new(place, current_user)
        results = service.send(:search_restaurants, place, current_user)
        expect(results).to eq([])
      end
    end
  end

  describe '#get_all_place_photos' do
    it 'returns an array of photo URLs' do
      allow(HTTParty).to receive(:get).and_return(
        double(success?: true, parsed_response: { 'result' => { 'photos' => [{ 'photo_reference' => 'abc' }] } })
      )

      service = RestaurantSearchService.new(place, current_user)
      photo_urls = service.send(:get_all_place_photos, { 'result' => { 'photos' => [{ 'photo_reference' => 'abc' }] } }, google_api_key, '123')
      expect(photo_urls).to eq(["https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=abc&key=#{google_api_key}"])
    end

    it 'returns an empty array if there are no photos' do
      allow(HTTParty).to receive(:get).and_return(
        double(success?: true, parsed_response: { 'result' => {} })
      )

      service = RestaurantSearchService.new(place, current_user)
      photo_urls = service.send(:get_all_place_photos, { 'result' => {} }, google_api_key, '123')
      expect(photo_urls).to eq([])
    end
  end

  describe '#get_photo_url' do
    it 'returns a valid photo URL' do
      service = RestaurantSearchService.new(place, current_user)
      photo_url = service.send(:get_photo_url, google_api_key, 'abc')
      expect(photo_url).to eq("https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=abc&key=#{google_api_key}")
    end
  end
end
