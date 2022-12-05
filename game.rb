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

  def p_grid
    @board_grid
  end

  def display_grid
    # row 1
    (TOP..BOTTOM).each do |row|
      (LEFT..RIGHT).each do |column|
        # set marker to whitespace or the existing marker
        marker = @board_grid[row][column].nil? ? ' ': @board_grid[row][column]
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

  # Returns true if the board has no nil values (all spaces filled), indicating a tie.
  def tie?
    @board_grid.any?(nil) ? false : true
  end
end

# Used to create and play tic tac toe games
class Game
  def initialize
    @board = Board.new
  end

  # The core gameplay loop
  def play
    @board.display_grid
  end
end

b = Board.new
p b.p_grid
b.display_grid
b.place_marker('X', 1, 2)
b.place_marker('X', 2, 2)
b.place_marker('X', 0, 2)
p b.p_grid
b.display_grid
p b.check_winner
