# frozen_string_literal: true

class RestaurantSearchService < ApplicationService
  def initialize(place, current_user)
    @place = place
    @current_user = current_user
  end

  def call
    search_restaurants(@place, @current_user)
  end

  private

  # Restaurant Search based on search input
  def search_restaurants(place, current_user)
    response = HTTParty.get('https://maps.googleapis.com/maps/api/place/textsearch/json',
                            query: { query: "restaurants in #{place}",
                                     key: ENV['GOOGLE_API_KEY'] })

    return [] unless response.success?

    results = response.parsed_response
    favourites = current_user.user_favourites.pluck(:google_place_id)
    results = results['results'].map do |result|
      {
        name: result['name'],
        address: result['formatted_address'],
        photo_urls: get_all_place_photos(results, ENV['GOOGLE_API_KEY'],
                                         result['place_id']),
        favourite: favourites.include?(result['place_id']),
        place_id: result['place_id']
      }
    end
  end

  # Get photos of any place
  def get_all_place_photos(result, api_key, place_id)
    photo_urls = []

    if result['result'] && result['result']['photos']
      # Process initial set of photos
      photo_urls += result['result']['photos'].map do |photo|
        get_photo_url(api_key, photo['photo_reference'])
      end
    end

    # Check if there are more photos
    while result['next_page_token'].present?
      next_page_token = result['next_page_token']

      # Make a request for the next set of photos
      response = HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{api_key}&pagetoken=#{next_page_token}")
      result = response.parsed_response

      next unless result['result'] && result['result']['photos']

      # Process additional set of photos
      photo_urls += result['result']['photos'].map do |photo|
        get_photo_url(api_key, photo['photo_reference'])
      end
    end

    photo_urls
  end

  # Returns photo url
  def get_photo_url(api_key, photo_reference)
    "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_reference}&key=#{api_key}"
  end
end
