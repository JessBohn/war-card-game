# frozen_string_literal: true

require_relative '../lib/card'

RSpec.describe Card do
  let(:card1) { Card.new('A', 'Hearts') }
  let(:card2) { Card.new('K', 'Diamonds') }

  it 'initializes with rank and suit' do
    expect(card1.rank).to eq('A')
    expect(card1.suit).to eq('Hearts')
  end

  it 'has a value based on rank' do
    expect(Card.new(2, 'Clubs').value).to eq(0) # '2' is the lowest rank
    expect(card1.value).to eq(12) # 'A' is the highest rank
    expect(card2.value).to eq(11) # 'K' is the second highest
  end

  it 'compares based on rank value' do
    expect(card1).to be > card2
  end
end
