# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post '/search', to: 'restaurants#search'
      resources :user_favourites, only: %i[create]
      delete '/user_favourites/:google_place_id', to: 'user_favourites#destroy', as: 'delete_user_favourite'
      devise_for :users, controllers: { sessions: 'api/v1/sessions' }
    end
  end
end
