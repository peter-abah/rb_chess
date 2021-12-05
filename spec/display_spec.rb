# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/display'

describe Display do
  describe '#board_representation' do
    context 'when called with a default board' do
      let(:board) { Board.new }

      it 'returns the correct display' do
        expected = <<~BOARD.chomp
             a b c d e f g h
            _________________
          1  r n b q k b n r  1
          2  p p p p p p p p  2
          3  - - - - - - - -  3
          4  - - - - - - - -  4
          5  - - - - - - - -  5
          6  - - - - - - - -  6
          7  P P P P P P P P  7
          8  R N B Q K B N R  8
            _________________
             a b c d e f g h
        BOARD
        board_display = described_class.board_representation(board)
        expect(board_display).to eq(expected)
      end
    end

    context 'when called with an empty board' do
      let(:board) { Board.new(fen_notation: '8/8/8/8/8/8/8/8') }

      it 'returns the correct display' do
        expected = <<~BOARD.chomp
             a b c d e f g h
            _________________
          1  - - - - - - - -  1
          2  - - - - - - - -  2
          3  - - - - - - - -  3
          4  - - - - - - - -  4
          5  - - - - - - - -  5
          6  - - - - - - - -  6
          7  - - - - - - - -  7
          8  - - - - - - - -  8
            _________________
             a b c d e f g h
        BOARD
        board_display = described_class.board_representation(board)
        expect(board_display).to eq(expected)
      end
    end

    context 'when called with a board with some chess pieces' do
      let(:board) { Board.new(fen_notation: '8/8/4krk1/8/pPP2Q2/8/RbbRbn1K/8') }

      it 'returns the correct display' do
        expected = <<~BOARD.chomp
             a b c d e f g h
            _________________
          1  - - - - - - - -  1
          2  - - - - - - - -  2
          3  - - - - k r k -  3
          4  - - - - - - - -  4
          5  p P P - - Q - -  5
          6  - - - - - - - -  6
          7  R b b R b n - K  7
          8  - - - - - - - -  8
            _________________
             a b c d e f g h
        BOARD
        board_display = described_class.board_representation(board)
        expect(board_display).to eq(expected)
      end
    end
  end
end