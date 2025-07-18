# frozen_string_literal: true

require_relative 'card'
# Deck class represents a standard deck of playing cards
class Deck
  attr_reader :cards

  def initialize
    @cards = Card::SUITS.product(Card::RANKS).map { |suit, rank| Card.new(rank, suit) }
    @cards.shuffle!
  end

  def deal(num_players)
    @cards.each_slice(@cards.size / num_players).to_a
  end
end
