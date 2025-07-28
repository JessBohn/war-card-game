# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'
# Game class represents the card game
class Game
  # Maximum number of rounds to prevent infinite loops
  MAX_ROUNDS = 5000
  NUM_PLAYERS_ALLOWED = [2, 4].freeze

  attr_reader :players, :deck
  attr_accessor :round

  # Initializes the game with a number of players
  # Leaving the variable num as an argument allows for flexibility in testing and future development
  # If a UI component were to be added, this could be replaced with a user inputted value
  def initialize(num = nil)
    @players = create_players(num)
    @deck = Deck.new
    @round = 1
  end

  def play
    puts "Number of players: #{players.size}"
    # Dealing cards should go within the play method because it is part of the game setup
    puts 'Dealing cards...'
    deal_cards

    puts 'Starting the war...'
    play_round(active_players) until game_over?
    winner = self.winner
    puts "\nWar is over in #{round - 1} battles! The winner is: #{winner.name}"
  end

  def deal_cards
    dealt_cards = deck.deal(players.size)
    players.each_with_index do |player, index|
      player.hand = dealt_cards[index]
    end
  end

  def winner
    game_over? ? players.max_by { |player| player.hand.size } : nil
  end

  private

  def create_players(num)
    num_players = NUM_PLAYERS_ALLOWED.include?(num) ? num : NUM_PLAYERS_ALLOWED.sample
    num_players.times.map { |i| Player.new("Player #{i + 1}", []) }
  end

  def play_round(player_set, winnings = [])
    plays = player_set.map { |p| [p, p.draw_card] }.to_h

    max_card = plays.values.compact.max
    winners = plays.select { |_, card| card == max_card }.keys
    winnings.concat(plays.values)

    if winners.size > 1
      winners = active_players(winners)
      war_cards = tie_handler(winners)
      winnings.concat(war_cards.compact)

      play_round(winners, winnings)
    else
      winners.first.add_cards(winnings)
    end
    round + 1
  end

  def active_players(player_set = players)
    player_set.reject(&:out_of_cards?)
  end

  def game_over?
    active_players.size == 1 || round > MAX_ROUNDS
  end

  def tie_handler(winners)
    war_cards = []
    winners.each do |winner|
      # subset = 3.times.map { winner.draw_card } # Face-down cards
      # subset.compact! # Remove nils if there are not enough cards
      # if subset.size < 3
      #   # Takes the last playable card and puts it back on top of the winner's hand
      #   last_playable = subset.pop
      #   winner.hand.unshift(last_playable) if last_playable
      # end
      # The below method involves no looping
      subset = 4.times.map { winner.draw_card } # Face-down card + face-up war card
      subset.compact! # Remove nils if there are not enough cards

      # last_playable = subset.pop
      # winner.hand.unshift(last_playable) if last_playable
      winner.hand.unshift(subset.pop)
      # It doesn't matter if the value is nil since compact will be called on the array
      war_cards.concat(subset)
    end
    war_cards
  end
end
