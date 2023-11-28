# frozen_string_literal: true

class CreateUserFavourites < ActiveRecord::Migration[7.1]
  def change
    create_table :user_favourites do |t|
      t.string :google_place_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
