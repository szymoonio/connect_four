require_relative '../lib/board'

RSpec.describe Board do
  describe "#update_board" do
    it "changes the bottommost value in the 3 column to X" do
      empty_board = described_class.new
      empty_board.update_board(3, 'X')
      expect(empty_board.game_state[5][3]).to eq('X')
    end

    it "doesn't change values at columns that are already full" do
      custom_grid = Array.new(6) { Array.new(7, 'X') }
      full_game_board = described_class.new(custom_grid)
      full_game_board.update_board(3, 'O')
      expect(full_game_board.game_state[0][3]).not_to eq('O')
    end
  end

  describe "#top" do
    it "returns 5 for empty columns" do
      empty_game_board = described_class.new
      top_spot = empty_game_board.top(0)
      expect(top_spot).to eq(5)
    end

    it "returns 3 if two rows are filled" do
      custom_grid = Array.new(6) { Array.new(7, ' ') }
      custom_grid[5][0] = 'X'
      custom_grid[4][0] = 'X'
      somewhat_filled_game_board = described_class.new(custom_grid)
      top_spot = somewhat_filled_game_board.top(0)
      expect(top_spot).to eq(3)
    end

    it "returns -1 if a column is full" do
      custom_grid = Array.new(6) { Array.new(7, 'X') }
      full_game_board = described_class.new(custom_grid)
      top_spot = full_game_board.top(0)
      expect(top_spot).to eq(-1)
    end
  end

  describe "#game_over?" do
    it "returns true for a diagonal" do
      custom_grid = Array.new(6) { Array.new(7, ' ') }
      custom_grid[0][1] = 'X'
      custom_grid[1][2] = 'X'
      custom_grid[2][3] = 'X'
      custom_grid[3][4] = 'X'
      game_finished = described_class.new(custom_grid)
      expect(game_finished).to be_game_over
    end

    it "returns true for a vertical" do
      custom_grid = Array.new(6) { Array.new(7, ' ') }
      custom_grid[0][1] = 'X'
      custom_grid[1][1] = 'X'
      custom_grid[2][1] = 'X'
      custom_grid[3][1] = 'X'
      game_finished = described_class.new(custom_grid)
      expect(game_finished).to be_game_over
    end

    it "returns true for a horizontal" do
      custom_grid = Array.new(6) { Array.new(7, ' ') }
      custom_grid[2][1] = 'X'
      custom_grid[2][2] = 'X'
      custom_grid[2][3] = 'X'
      custom_grid[2][4] = 'X'
      game_finished = described_class.new(custom_grid)
      expect(game_finished).to be_game_over
    end

    it "returns false for no line" do
      custom_grid = Array.new(6) { Array.new(7, ' ') }
      game_not_finished = described_class.new(custom_grid)
      expect(game_not_finished).not_to be_game_over
    end
  end

  describe "#get_input" do
    context "valid input" do
      let(:player) { double('player', get_sign: 'X') }
      subject(:game) { described_class.new }
      before do
        allow(game).to receive(:gets).and_return("3\n")
      end
      it "returns valid input" do
        valid_input = game.get_input
        expect(valid_input).to eq(3)
      end
    end
    context "invalid input once" do
      let(:player) { double('player', get_sign: 'X') }
      let(:custom_grid) do
        grid = Array.new(6) { Array.new(7, ' ') }
        (0..5).each do |row|
          grid[row][0] = 'X'
        end
        grid
      end
      subject(:game) { described_class.new(custom_grid) }

      before do
        allow(game).to receive(:gets).and_return("0\n")
      end
      it "returns nil for invalid input" do
        invalid_input = game.get_input
        expect(invalid_input).to be_nil
      end

    end
  end

  describe "#player_turn" do
    let(:player) { double('player', get_sign: 'X') }
    subject(:game) { described_class.new }
    before do
      allow(game).to receive(:puts)
      allow(player).to receive(:get_name)
      allow(game).to receive(:get_input).and_return(3)
    end 
    it "sends an input to the board" do
      expect(game).to receive(:update_board).with(game.get_input, player.get_sign)
      game.player_turn(player)
    end
  end
end