# frozen_string_literal: true

require_relative './lib/board'
require_relative './lib/game'

play = true
while play
  game = Game.new
  game.play
  puts 'If you want to play again, enter "y"!'
  play = false unless gets.chomp.downcase == 'y'
end
puts 'Thanks for playing.'
