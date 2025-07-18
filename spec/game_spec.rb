# frozen_string_literal: true

require_relative '../lib/deck'
require_relative '../lib/card'
require_relative '../lib/player'
require_relative '../lib/game'
require 'pry'

RSpec.describe Game do
  let(:deck) { Deck.new }
  let(:num_players) { 2 }
  let(:game) { Game.new(num_players) }

  it 'initializes with players and a deck' do
    expect(game.players.size).to eq(2)
    expect(game.deck.cards.size).to eq(52)
  end
end
