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

  def place_marker(marker, row, column)
    # if there is no marker at @board_grid[row][column], set the marker there
    return 'ERROR: Invalid row/column' unless row.between?(TOP, BOTTOM) && column.between?(LEFT, RIGHT)
    return 'You cannot place a marker here.' unless @board_grid[row][column].nil?

    @board_grid[row][column] = marker
  end
end

b = Board.new
p b.p_grid
b.place_marker('X', 1, 2)
p b.p_grid
