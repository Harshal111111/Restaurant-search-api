# frozen_string_literal: true

module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        restaurants = RestaurantSearchService.call(restaurant_params[:search_place], current_user)
        render json: { restaurants: restaurants }
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private

      def restaurant_params
        params.require(:restaurant).permit(:search_place)
      end
    end
  end
end
