# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password123' }

    factory :user_with_favourites do
      transient do
        favourites_count { 3 }
      end
      after(:create) do |user, evaluator|
        create_list(:user_favourite, evaluator.favourites_count, user: user)
      end
    end
  end
end
