# frozen_string_literal: true

# Card class represents a playing card
# It includes Comparable to allow for easy comparison of cards based on their rank
class Card
  include Comparable
  attr_reader :rank, :suit

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].freeze
  # Not relevant to the current context, but included for completeness & ease of deck creation
  SUITS = %w[Hearts Diamonds Clubs Spades].freeze

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    RANKS.index(rank)
  end

  def <=>(other)
    value <=> other.value
  end
end
