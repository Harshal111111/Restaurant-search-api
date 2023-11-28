# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserFavourite, type: :model do
  it 'is associated with a user' do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end
end
