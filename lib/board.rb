require_relative 'player'

class Board
  attr_reader :game_state

  def initialize(game_state = Array.new(6) { Array.new(7, ' ') }, game_over = false)
    @game_state = game_state
  end

  def update_board(col, sign)
    row = self.top(col)
    @game_state[row][col] = sign
  end

  def top(col)
    i = 5
    while i >= 0 && game_state[i][col] != ' ' do
      i -= 1
    end
    return i
  end

  def game_over?
    (0..3).each do |col|
      (0..5).each do |row|
        if game_state[row][col] != ' ' && game_state[row][col] == game_state[row][col + 1] && game_state[row][col + 1] == game_state[row][col + 2] && game_state[row][col + 2] == game_state[row][col + 3]
          return true
        end
      end
    end
    (0..2).each do |row|
      (0..6).each do |col|
        if game_state[row][col] != ' ' && game_state[row][col] == game_state[row + 1][col] && game_state[row + 1][col] == game_state[row + 2][col] && game_state[row + 2][col] == game_state[row + 3][col]
          return true
        end
      end
    end
    (0..2).each do |row|
      (0..3).each do |col|
        if game_state[row][col] != ' ' && game_state[row][col] == game_state[row + 1][col + 1] && game_state[row + 1][col + 1] == game_state[row + 2][col + 2] && game_state[row + 2][col + 2] == game_state[row + 3][col + 3]
          return true
        end
      end
    end
    (3..5).each do |row|
      (0..3).each do |col|
        if game_state[row][col] != ' ' && game_state[row][col] == game_state[row - 1][col + 1] && game_state[row - 1][col + 1] == game_state[row - 2][col + 2] && game_state[row - 2][col + 2] == game_state[row - 3][col + 3]
          return true
        end
      end
    end
    return false
  end

  def display_board
    game_state.each_with_index do |row, index|
      puts row.join(" | ")
      puts "---------------------------"
    end
  end

  def get_input
    input = gets.chomp.to_i
    if input.between?(0, 6) && top(input) > -1
      input
    else
      nil
    end
  end

  def player_turn(curr_player)
    while true do
      puts "Choose a column #{curr_player.get_name}"
      col = get_input
      break if col
    end
    update_board(col, curr_player.get_sign)
    display_board
  end

  def play_game(p1, p2)
    curr_player = p1
    until game_over? do
      curr_player = curr_player == p1 ? p2 : p1
      player_turn(curr_player)
    end
    puts "Congrats #{curr_player.get_name}! You've won!"
  end
end