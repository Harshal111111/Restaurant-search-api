# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has many user favourites' do
    association = described_class.reflect_on_association(:user_favourites)
    expect(association.macro).to eq(:has_many)
  end
end
