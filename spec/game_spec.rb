# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game_test) { described_class.new }
  describe '#validate_move' do
    context 'when the wrong number of inputs are given' do
      it 'returns false with 0 inputs' do
        return_val = game_test.validate_move([])
        expect(return_val).to be false
      end
      it 'returns false with 1 input' do
        return_val = game_test.validate_move(['top'])
        expect(return_val).to be false
      end
      it 'returns false with 3 inputs' do
        return_val = game_test.validate_move(%w[top left something])
        expect(return_val).to be false
      end
    end
    context 'when 2 input words are given' do
      it 'returns false when row word is invalid' do
        return_val = game_test.validate_move(%w[center right])
        expect(return_val).to be false
      end
      it 'returns false when col word is invalid' do
        return_val = game_test.validate_move(%w[bottom center])
        expect(return_val).to be false
      end
      it 'returns true for top left' do
        return_val = game_test.validate_move(%w[top left])
        expect(return_val).to be true
      end
      it 'returns true for middle middle' do
        return_val = game_test.validate_move(%w[middle middle])
        expect(return_val).to be true
      end
      it 'returns true for bottom right' do
        return_val = game_test.validate_move(%w[bottom right])
        expect(return_val).to be true
      end
    end
  end

  describe '#move' do
    context 'when player input is valid' do
      subject(:game_move_valid) { described_class.new }

      before do
        allow(game_move_valid).to receive(:puts)
        player_move = "top left\n"
        allow(game_move_valid).to receive(:gets).and_return(player_move)
      end

      it 'stops loop with no reprompt' do
        error_msg = 'Invalid move/input. Try again.'
        expect(game_move_valid).to_not receive(:puts).with(error_msg)
        game_move_valid.move
      end
    end
    context 'when player input is first invalid, then valid' do
      subject(:game_move_invalid) { described_class.new }

      before do
        allow(game_move_invalid).to receive(:puts)
        invalid = "x\n"
        valid = "top left\n"
        allow(game_move_invalid).to receive(:gets).and_return(invalid, valid)
      end

      it 'completes loop and displays error message once' do
        error_msg = 'Invalid move/input. Try again.'
        expect(game_move_invalid).to receive(:puts).with(error_msg).exactly(1).time
        game_move_invalid.move
      end
    end
    context 'when player input is invalid twice, then valid' do
      subject(:game_move_invalid2) { described_class.new }

      before do
        allow(game_move_invalid2).to receive(:puts)
        invalid1 = "left top\n"
        invalid2 = "top top left middle\n"
        valid = "top left\n"
        allow(game_move_invalid2).to receive(:gets).and_return(invalid1, invalid2, valid)
      end

      it 'completes loop and displays error message once' do
        error_msg = 'Invalid move/input. Try again.'
        expect(game_move_invalid2).to receive(:puts).with(error_msg).exactly(2).times
        game_move_invalid2.move
      end
    end
  end

  describe '#toggle_player' do
    context 'starting with player 1' do
      subject(:game_p1_toggle) { described_class.new }
      it 'toggles player 1 to player 2' do
        expect { game_p1_toggle.toggle_player }.to change { game_p1_toggle.instance_variable_get(:@player_no) }.to(2)
      end
      it 'toggles X to O' do
        expect { game_p1_toggle.toggle_player }.to change { game_p1_toggle.instance_variable_get(:@marker) }.to('O')
      end
    end
    context 'starting with player 2' do
      subject(:game_p2_toggle) { described_class.new }
      before(:each) do
        game_p2_toggle.instance_variable_set(:@player_no, 2)
        game_p2_toggle.instance_variable_set(:@marker, 'O')
      end
      it 'toggles player 2 to player 1' do
        expect { game_p2_toggle.toggle_player }.to change { game_p2_toggle.instance_variable_get(:@player_no) }.to(1)
      end
      it 'toggles O to X' do
        expect { game_p2_toggle.toggle_player }.to change { game_p2_toggle.instance_variable_get(:@marker) }.to('X')
      end
    end
  end

  describe '#display_winner' do
    subject(:game_display_winner) { described_class.new }
    context 'when player 1 turn' do
      before do
        allow(game_display_winner.instance_variable_get(:@board)).to receive(:display_grid)
      end
      it 'displays player 1 win' do
        msg = 'Player 1 (X) wins!'
        expect(game_display_winner).to receive(:puts).with(msg).once
        game_display_winner.display_winner
      end
    end
    context 'when player 2 turn' do
      before do
        allow(game_display_winner.instance_variable_get(:@board)).to receive(:display_grid)
        game_display_winner.instance_variable_set(:@player_no, 2)
        game_display_winner.instance_variable_set(:@marker, 'O')
      end
      it 'displays player 2 win' do
        msg = 'Player 2 (O) wins!'
        expect(game_display_winner).to receive(:puts).with(msg).once
        game_display_winner.display_winner
      end
    end
  end

  describe '#display_tie' do
    subject(:game_display_tie) { described_class.new }
    context 'when player 1 turn' do
      before do
        allow(game_display_tie.instance_variable_get(:@board)).to receive(:display_grid)
      end
      it 'displays tie' do
        msg = "It's a tie! Game over."
        expect(game_display_tie).to receive(:puts).with(msg).once
        game_display_tie.display_tie
      end
    end
    context 'when player 2 turn' do
      before do
        allow(game_display_tie.instance_variable_get(:@board)).to receive(:display_grid)
        game_display_tie.instance_variable_set(:@player_no, 2)
        game_display_tie.instance_variable_set(:@marker, 'O')
      end
      it 'displays tie' do
        msg = "It's a tie! Game over."
        expect(game_display_tie).to receive(:puts).with(msg).once
        game_display_tie.display_tie
      end
    end
  end
end
