# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#winner?' do
    context 'when there are no markers placed' do
      subject(:board_winner_none) { described_class.new }
      it { is_expected.to_not be_winner }
    end
    context 'when there are markers not matched in a row, column, diagonal' do
      no_winner_grid = [%w[X X O], %w[O O X], %w[X O X]]
      subject(:board_no_winner) { described_class.new(no_winner_grid) }
      it { is_expected.to_not be_winner }
    end
    context 'when there are markers placed in a row' do
      winning_row_grid = [%w[O O O], [nil, nil, nil], [nil, nil, nil]]
      subject(:board_winner_row) { described_class.new(winning_row_grid) }
      it { is_expected.to be_winner }
    end
    context 'when there are markers placed in a column' do
      winning_column_grid = [['X', nil, nil], ['X', nil, nil], ['X', nil, nil]]
      subject(:board_winner_column) { described_class.new(winning_column_grid) }
      it { is_expected.to be_winner }
    end
    context 'when there are markers placed in a diagonal' do
      winning_diagonal_grid = [['X', nil, nil], [nil, 'X', nil], [nil, nil, 'X']]
      subject(:board_winner_diagonal) { described_class.new(winning_diagonal_grid) }
      it { is_expected.to be_winner }
    end
  end

  describe '#tie?' do
    context 'when there are no markers placed' do
      subject(:board_tie_none) { described_class.new }
      it { is_expected.to_not be_tie }
    end
    context 'when a game is incomplete' do
      incomplete_grid = [['X', 'O', nil], ['O', 'X', nil], ['X', nil, nil]]
      subject(:board_tie_incomplete) { described_class.new(incomplete_grid) }
      it { is_expected.to_not be_tie }
    end
    context 'when a game has a winner before grid is full' do
      incomplete_winner_grid = [['X', 'O', nil], ['X', 'O', nil], ['X', nil, nil]]
      subject(:board_tie_incomplete_winner) { described_class.new(incomplete_winner_grid) }
      it { is_expected.to_not be_tie }
    end
    context 'when a game has no winner and grid is full' do
      full_grid = [%w[X X O], %w[O O X], %w[X O X]]
      subject(:board_tie_full) { described_class.new(full_grid) }
      it { is_expected.to be_tie }
    end
    context 'when a game has a winner and grid is full' do
      full_winner_grid = [%w[X X O], %w[X O O], %w[X O X]]
      subject(:board_tie_full_winner) { described_class.new(full_winner_grid) }
      it { is_expected.to_not be_tie }
    end
  end

  describe '#place_marker' do
    context 'there is no marker at desired spot' do
      subject(:board_place_empty) { described_class.new }
      it 'returns the marker character placed' do
        marker = 'X'
        return_val = board_place_empty.place_marker(marker, TOP, LEFT)
        expect(return_val).to eq(marker)
      end
    end
    context 'there is already a marker at desired spot' do
      grid_place_taken = [['O', nil, 'X'], ['O', 'X', nil], [nil, nil, nil]]
      subject(:board_place_taken) { described_class.new(grid_place_taken) }
      it 'returns a warning message to the user' do
        marker = 'X'
        warning_msg = 'You cannot place a marker here.'
        return_val = board_place_taken.place_marker(marker, TOP, LEFT)
        expect(return_val).to eq(warning_msg)
      end
    end
    context 'an invalid row/col was given' do
      subject(:board_place_invalid) { described_class.new }
      it 'returns an error message' do
        marker = 'X'
        error_msg = 'ERROR: Invalid row/column'
        return_val = board_place_invalid.place_marker(marker, 3, 5)
        expect(return_val).to eq(error_msg)
      end
    end
  end
end
