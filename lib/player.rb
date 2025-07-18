# frozen_string_literal: true

# Player class represents a player in the card game
class Player
  attr_reader :name
  attr_accessor :hand

  def initialize(name, cards)
    @name = name
    @hand = cards
  end

  def draw_card
    # Draw the top card from the player's hand (first card in the array)
    @hand.shift
  end

  def add_cards(cards)
    @hand.concat(cards)
  end

  def out_of_cards?
    @hand.empty?
  end
end
