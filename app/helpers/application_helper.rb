# frozen_string_literal: true

module ApplicationHelper
  def is_valid_place_id(place_id)
    response = HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{ENV['GOOGLE_API_KEY']}")
    response['result'].present?
  end
end
