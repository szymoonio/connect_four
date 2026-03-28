require_relative 'lib/board'
require_relative 'lib/player'

game = Board.new
puts "Hello player one! Choose your name and sign\nExample:\nJohn X"
n1, s1 = gets.chomp.split(' ')
p1 = Player.new(n1, s1)
puts "Hello player two! Choose your name and sign\nExample:\nMac O"
n2, s2 = gets.chomp.split(' ')
p2 = Player.new(n2, s2)
game.play_game(p1, p2)
