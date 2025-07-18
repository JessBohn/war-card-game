# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'
# Game class represents the card game
class Game
  attr_reader :players, :deck, :winner

  # Initializes the game with a number of players
  # Leaving the variable num as an argument allows for flexibility in testing and future development
  # If a UI component were to be added, this could be replaced with a user inputted value
  def initialize(num = nil)
    @players = choose_players(num)
    @deck = Deck.new
    @winner = nil
  end

  def play
    puts 'This means War! (the game)...'
    puts "Number of players: #{players.size}"

    puts 'Dealing cards...'
    deal_cards

    puts 'Starting the battle...'
    until game_over?
      active_players = players.reject(&:out_of_cards?)
      play_round(active_players)
    end
    set_winner
    puts "\nWar is over! The winner is: #{winner.name}"
  end

  def deal_cards
    dealt_cards = deck.deal(players.size)
    players.each_with_index do |player, index|
      player.hand = dealt_cards[index]
    end
  end

  private

  def choose_players(num)
    allowed_numbers = [2, 4]
    # If no number is provided, randomly choose between 2 or 4 players
    num_players = num || allowed_numbers.sample
    # If there were a UI component to this, the given number would be validated and an error raised if invalid
    # num_players = allowed_numbers.include?(num) ? num : allowed_numbers.sample
    num_players.times.map { |i| Player.new("Player #{i + 1}", []) }
  end

  def play_round(active_players, winnings = [])
    plays = active_players.map { |p| [p, p.draw_card] }.to_h

    max_card = plays.values.compact.max
    winners = plays.select { |_, card| card == max_card }.keys
    winnings.concat(plays.values)
    if winners.size > 1
      war_cards = []

      winners.each do |winner|
        3.times { war_cards << winner.draw_card } # Face-down cards
        war_cards << winner.draw_card             # Face-up war card
      end

      winnings.concat(war_cards.compact)
      winners.reject!(&:out_of_cards?)

      return if winners.empty?

      play_round(winners, winnings)
    else
      winners.first.add_cards(winnings)
    end
  end

  def game_over?
    players.count { |player| !player.out_of_cards? } <= 1
  end

  def set_winner
    @winner = @players.max_by { |player| player.hand.size }
  end
end
