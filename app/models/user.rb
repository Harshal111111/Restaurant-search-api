# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :user_favourites
end
