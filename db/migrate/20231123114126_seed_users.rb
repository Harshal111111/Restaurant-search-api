# frozen_string_literal: true

class SeedUsers < ActiveRecord::Migration[7.1]
  def change
    User.create(email: 'user@yopmail.com', password: 'Password@123', password_confirmation: 'Password@123')
  end
end
