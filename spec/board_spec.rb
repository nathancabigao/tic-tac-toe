# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#winner?' do
    context 'when there are no markers placed' do
      subject(:board_winner_none) { described_class.new }
      it { is_expected.to_not be_winner }
    end
    context 'when there are markers not matched in a row, column, diagonal' do
      no_winner_grid = [%w[x x o], %w[o o x], %w[x o x]]
      subject(:board_no_winner) { described_class.new(no_winner_grid) }
      it { is_expected.to_not be_winner }
    end
    context 'when there are markers placed in a row' do
      winning_row_grid = [%w[o o o], [nil, nil, nil], [nil, nil, nil]]
      subject(:board_winner_row) { described_class.new(winning_row_grid) }
      it { is_expected.to be_winner }
    end
    context 'when there are markers placed in a column' do
      winning_column_grid = [['x', nil, nil], ['x', nil, nil], ['x', nil, nil]]
      subject(:board_winner_column) { described_class.new(winning_column_grid) }
      it { is_expected.to be_winner }
    end
    context 'when there are markers placed in a diagonal' do
      winning_diagonal_grid = [['x', nil, nil], [nil, 'x', nil], [nil, nil, 'x']]
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
      incomplete_grid = [['x', 'o', nil], ['o', 'x', nil], ['x', nil, nil]]
      subject(:board_tie_incomplete) { described_class.new(incomplete_grid) }
      it { is_expected.to_not be_tie }
    end
    context 'when a game has a winner before grid is full' do
      incomplete_winner_grid = [['x', 'o', nil], ['x', 'o', nil], ['x', nil, nil]]
      subject(:board_tie_incomplete_winner) { described_class.new(incomplete_winner_grid) }
      it { is_expected.to_not be_tie }
    end
    context 'when a game has no winner and grid is full' do
      full_grid = [%w[x x o], %w[o o x], %w[x o x]]
      subject(:board_tie_full) { described_class.new(full_grid) }
      it { is_expected.to be_tie }
    end
    context 'when a game has a winner and grid is full' do
      full_winner_grid = [%w[x x o], %w[x o o], %w[x o x]]
      subject(:board_tie_full_winner) { described_class.new(full_winner_grid) }
      it { is_expected.to_not be_tie }
    end
  end
end
