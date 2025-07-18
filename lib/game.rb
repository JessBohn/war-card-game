# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'
# Game class represents the card game
class Game
  attr_reader :players, :deck

  # Initializes the game with a number of players
  # Leaving the variable num as an argument allows for flexibility in testing and future development
  # If a UI component were to be added, this could be replaced with a user inputted value
  def initialize(num = nil)
    @players = choose_players(num)
    @deck = Deck.new
  end

  def play
    # Logic for playing the game
  end

  private

  def play_round(active_players, winnings = [])
    # Logic for playing a round of the game
    # This would involve comparing cards, determining the winner, etc.
  end
end
