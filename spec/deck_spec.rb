# frozen_string_literal: true

require_relative '../lib/card'
require_relative '../lib/deck'

RSpec.describe Deck do
  let(:deck) { Deck.new }

  it 'initializes with 52 cards' do
    expect(deck.cards.size).to eq(52)
  end

  it 'has the cards in a random order (shuffled)' do
    original_order = deck.cards.dup
    deck.cards.shuffle!
    expect(deck.cards).not_to eq(original_order)
  end

  it 'equally deals cards to players' do
    dealt_cards = deck.deal(2)
    expect(dealt_cards.size).to eq(2)
    expect(dealt_cards.first.size).to eq(26)
  end

  context 'when there are 4 players' do
    let(:players) { %w[player1 player2 player3 player4] }

    it 'deals cards evenly' do
      deck = Deck.new
      dealt_cards = deck.deal(players.size)
      expect(dealt_cards.size).to eq(players.size)
      expect(dealt_cards.all? { |hand| hand.size == 13 }).to be true
    end
  end
end
