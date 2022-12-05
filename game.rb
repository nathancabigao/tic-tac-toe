# frozen_string_literal: true

# Constants for rows and columns
TOP = LEFT = 0
MIDDLE = 1
BOTTOM = RIGHT = 2

# Used to create 3x3 grid boards for the game.
class Board
  def initialize
    @board_grid = Array.new(3) { Array.new(3) } # 3 rows of [nil, nil, nil]
  end

  def display_grid
    (TOP..BOTTOM).each do |row|
      (LEFT..RIGHT).each do |column|
        # set marker to either whitespace or the existing marker.
        marker = @board_grid[row][column].nil? ? ' ' : @board_grid[row][column]
        print " #{marker} "
        print '|' unless column == RIGHT
      end
      puts "\n------------" unless row == BOTTOM
      puts "\n" if row == BOTTOM
    end
  end

  def place_marker(marker, row, column)
    # if there is no marker at @board_grid[row][column], set the marker there
    return 'ERROR: Invalid row/column' unless row.between?(TOP, BOTTOM) && column.between?(LEFT, RIGHT)
    return 'You cannot place a marker here.' unless @board_grid[row][column].nil?

    @board_grid[row][column] = marker
  end

  # Checks every area if there is a winning combination
  def winner?
    # Check rows
    return true if check_rows

    # Check columns
    return true if check_columns

    # Check diagonals
    check_diagonals
  end

  def space_empty?(row, col)
    @board_grid[row][col].nil?
  end

  # Returns true if the board has no nil values (all spaces filled), indicating a tie.
  def tie?
    (TOP..BOTTOM).each do |row|
      return false if @board_grid[row].any?(nil)
    end
    # No row has no nils, so it has to be a tie.
    true
  end

  private

  # Checks the rows for winning lines
  def check_rows
    (TOP..BOTTOM).each do |row|
      return true if check_line(@board_grid[row])
    end
    false
  end

  # Checks the columns for winning lines
  def check_columns
    (LEFT..RIGHT).each do |column|
      line = [@board_grid[TOP][column], @board_grid[MIDDLE][column], @board_grid[BOTTOM][column]]
      return true if check_line(line)
    end
    false
  end

  # Checks the diagonals for winning lines
  def check_diagonals
    # Check top left to bottom right
    line = [@board_grid[TOP][LEFT], @board_grid[MIDDLE][MIDDLE], @board_grid[BOTTOM][RIGHT]]
    return true if check_line(line)

    # Check bottom left to top right
    line = [@board_grid[BOTTOM][LEFT], @board_grid[MIDDLE][MIDDLE], @board_grid[TOP][RIGHT]]
    check_line(line)
  end

  # Checks a certain line to see if it is a winning line.
  def check_line(line)
    # If anything is nil (empty), it cannot be a winning line.
    return false unless line.none?(&:nil?)

    # Check if all elements are the same and return the result.
    line.uniq.length == 1
  end
end

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

  private

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

play = true
while play
  game = Game.new
  game.play
  puts 'If you want to play again, enter "y"!'
  play = false unless gets.chomp.downcase == 'y'
end
puts 'Thanks for playing.'
