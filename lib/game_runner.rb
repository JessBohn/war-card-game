# frozen_string_literal: true

require_relative 'game'
# Main script to run the War card game

puts 'This means War! (the game)...'
# For a completely randomized game, I will not set a fixed number of players
game = Game.new
game.play
