# frozen-string-literal: true

require_relative './board'

# Used to create and play tic tac toe games
class Game
  def initialize
    @board = Board.new
    @player_no = 1
    @marker = 'X'
    @game_end = false
    @game_tie = false
  end

  def welcome
    puts 'Welcome to Tic Tac Toe!'
    puts 'To play, enter the desired row position, followed by a space, and the desired column position.'
    puts 'Examples of proper input [row] [column]: "top right", "middle middle", or "bottom left".'
  end

  # The core gameplay loop
  def play
    welcome

    # Loop starts here
    until @game_end || @game_tie
      @board.display_grid
      # Player prompt+move+validate
      move
      # Player win? tie?
      check_win_or_tie
      # Toggle player_no and marker
      toggle_player unless @game_end || @game_tie
      # Loop end
    end

    display_winner if @game_end
    display_tie if @game_tie
  end

  def check_win_or_tie
    @game_end = @board.winner?
    @game_tie = @board.tie? unless @game_end
  end

  def toggle_player
    @player_no = @player_no == 1 ? 2 : 1
    @marker = @marker == 'X' ? 'O' : 'X'
  end

  def display_winner
    @board.display_grid
    puts "Player #{@player_no} (#{@marker}) wins!"
  end

  def display_tie
    @board.display_grid
    puts "It's a tie! Game over."
  end

  # Prompts the user to enter a position to place their marker.
  def move
    valid = false
    until valid
      puts "Player #{@player_no} (#{@marker}), your move:"
      player_move = gets.chomp.downcase.split

      # Ensure valid input before moving on
      valid = validate_move(player_move)

      row_num = %w[top middle bottom].index(player_move[0]) if valid
      col_num = %w[left middle right].index(player_move[1]) if valid
      valid = @board.space_empty?(row_num, col_num) if valid
      puts 'Invalid move/input. Try again.' unless valid
    end
    @board.place_marker(@marker, row_num, col_num)
  end

  # Checks if the given move is valid
  def validate_move(player_move)
    # Ensure we have both a row and column input, no more or less
    return false unless player_move.size == 2

    # Check row and column inputs are valid keywords
    row_input = [player_move[0]]
    col_input = [player_move[1]]
    return false unless (row_input - %w[top middle bottom]).empty?
    return false unless (col_input - %w[left middle right]).empty?

    true
  end
end
