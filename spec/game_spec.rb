# frozen_string_literal: true

require_relative '../lib/deck'
require_relative '../lib/card'
require_relative '../lib/player'
require_relative '../lib/game'

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

  context '#play' do
    it 'plays the game until there is a winner' do
      game = Game.new(2)
      expect { game.play }.to change { game.winner }.from(nil)
    end
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

    context 'handles a war scenario correctly' do
      let(:player1) { Player.new('Alice', [Card.new('A', 'Hearts'), Card.new(3, 'Diamonds')]) }
      let(:player2) { Player.new('Bob', [Card.new(2, 'Clubs'), Card.new(2, 'Spades')]) }

      it 'gives the winnings to the winner' do
        # From start to finish of a round in a 2-player game without tying, the rounder winner's hand will technically
        # only overall increase by 1 card. They give one up to play, then take the 2 cards played in the round, e.g.
        # player's hand size -1 then +2 equals +1 overall.
        expect { game.send(:play_round, [player1, player2], []) }.to change { player1.hand.size }.by(1).or change {
          player2.hand.size
        }.by(1)
      end
    end
  end
end
