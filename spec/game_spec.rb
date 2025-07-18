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

  it 'starts with each player having an empty hand' do
    expect(game.players.all? { |player| player.hand.empty? }).to be true
  end

  context '#choose_players' do
    it 'chooses the correct number of players' do
      expect(game.players.size).to eq(num_players)
    end

    it 'defaults to 2 or 4 players if no argument is given' do
      game = Game.new
      expect(game.players.size).to eq(2).or eq(4)
    end
  end

  context '#deal_cards' do
    it 'deals cards to each player' do
      game.deal_cards
      expect(game.players.all? { |player| !player.hand.empty? }).to be true
    end

    it 'deals cards evenly among players' do
      game.deal_cards
      expect(game.players.map(&:hand).map(&:size).uniq.size).to eq(1)
    end
  end

  context '#play_round' do
    it 'plays a round of the game' do
      game.deal_cards
      expect { game.send(:play_round, game.players) }.to(change { game.players.map(&:hand).map(&:size) })
    end
  end
end
