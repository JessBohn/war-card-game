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
    let(:cards1) { [Card.new('A', 'Hearts'), Card.new(3, 'Diamonds')] }
    let(:cards2) { [Card.new(2, 'Clubs'), Card.new(2, 'Spades')] }
    let(:player1) { Player.new('Jessica', cards1) }
    let(:player2) { Player.new('Bob', cards2) }
    it 'plays a round of the game' do
      game.deal_cards
      expect { game.send(:play_round, game.players) }.to(change { game.players.map(&:hand).map(&:size) })
    end

    context 'handles a war scenario correctly' do
      it 'gives the winnings to the winner' do
        # From start to finish of a round in a 2-player game without tying, the rounder winner's hand will technically
        # only overall increase by 1 card. They give one up to play, then take the 2 cards played in the round, e.g.
        # player's hand size -1 then +2 equals +1 overall.
        expect { game.send(:play_round, [player1, player2], []) }.to change { player1.hand.size }.by(1).or change {
          player2.hand.size
        }.by(1)
      end
    end

    context 'handles when there is more than one winner in a round' do
      let(:cards1) do
        [Card.new('A', 'Hearts'), Card.new(3, 'Diamonds'), Card.new(5, 'Hearts'), Card.new(7, 'Diamonds'),
         Card.new(9, 'Hearts')]
      end
      let(:cards2) { [Card.new('A', 'Clubs'), Card.new(2, 'Spades')] }
      let(:player1) { Player.new('Sarah', cards1) }
      let(:player2) { Player.new('Ryan', cards2) }

      it 'plays through tie logic without error' do
        expect { game.send(:play_round, [player1, player2], []) }.to_not raise_error
      end
    end
  end

  context '#tie_handler' do
    let(:game_with_tie) { Game.new(2) }
    let(:cards1) do
      [Card.new('A', 'Hearts'), Card.new(3, 'Diamonds'), Card.new(5, 'Hearts'), Card.new(7, 'Diamonds'),
       Card.new(9, 'Hearts')]
    end
    let(:cards2) { [Card.new('A', 'Clubs'), Card.new(2, 'Spades')] }
    let(:player1) { game_with_tie.players[0] }
    let(:player2) { game_with_tie.players[1] }

    context 'when one of the tied winners has less than 3 cards' do
      it 'handles the tie correctly' do
        player1.hand = cards1
        player2.hand = cards2
        winnings = []
        expect { game_with_tie.send(:play_round, [player1, player2], winnings) }.to_not raise_error
        expect(player2.out_of_cards?).to be true
        expect(winnings.size).to eq(7)
      end
    end

    context 'when all tied winners have at least 3 cards' do
      # This is a modified deck to assign half a deck to each player,
      # ensuring the first card for each player ties on an Ace
      let(:modified_deck) do
        Deck.new.cards.reject do |card|
          card.rank == 'A' && %w[Hearts Clubs].include?(card.suit)
        end
      end
      let(:cards1) do
        modified_deck.shift(25).unshift(Card.new('A', 'Hearts'))
      end
      let(:cards2) do
        modified_deck.shift(25).unshift(Card.new('A', 'Clubs'))
      end

      it 'handles the tie correctly' do
        player1.hand = cards1
        player2.hand = cards2
        winnings = []
        expect { game_with_tie.send(:play_round, [player1, player2], winnings) }.to_not raise_error
        # winnings include the original tied cards plus the 3 face-down cards from each player, plus the next face-up card
        # from each player, so 2 + 2 * 3 + 2 = 10
        expect(winnings.size).to eq(10)
      end
    end

    context 'when there is a tie within a tie' do
      let(:cards1) do
        [Card.new('A', 'Hearts'), Card.new(3, 'Diamonds'), Card.new(5, 'Hearts'), Card.new(7, 'Diamonds'),
         Card.new(9, 'Hearts'), Card.new(10, 'Diamonds'), Card.new('K', 'Hearts'), Card.new('Q', 'Diamonds'),
         Card.new('J', 'Clubs')]
      end
      let(:cards2) do
        [Card.new('A', 'Clubs'), Card.new(2, 'Spades'), Card.new(4, 'Diamonds'), Card.new(6, 'Hearts'),
         Card.new(9, 'Clubs'), Card.new(10, 'Spades'), Card.new('K', 'Diamonds'), Card.new('Q', 'Clubs'),
         Card.new(5, 'Spades')]
      end
      it 'handles the tie correctly' do
        player1.hand = cards1
        player2.hand = cards2
        winnings = []
        expect { game_with_tie.send(:play_round, [player1, player2], winnings) }.to_not raise_error
        expect(winnings.size).to eq(cards1.size + cards2.size)
        expect(winnings.size).to eq(18)
      end
    end
  end
end
