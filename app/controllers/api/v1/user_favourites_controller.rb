# frozen_string_literal: true

module Api
  module V1
    class UserFavouritesController < ApplicationController
      def create
        if is_valid_place_id(params['google_place_id']) && current_user.user_favourites.find_or_create_by(google_place_id: params['google_place_id'])
          render json: {
            messages: 'Successfully Marked as favourite',
            success: true
          }, status: :ok
        else
          render json: {
            messages: 'Place id is not valid',
            success: false
          }, status: :bad_request
        end
      end

      def destroy
        if is_valid_place_id(params['google_place_id'])
          place = current_user.user_favourites.find_by(google_place_id: params['google_place_id'])
          if place.present? && place.destroy
            render json: {
              messages: 'Successfully removed from favourites',
              success: true
            }, status: :ok
          else
            render json: {
              messages: 'Record not found',
              success: false
            }, status: :not_found
          end
        else
          render json: {
            messages: 'Place id is not valid',
            success: false
          }, status: :bad_request
        end
      end
    end
  end
end
