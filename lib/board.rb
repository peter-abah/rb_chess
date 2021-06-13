# frozen_string_literal: true

require 'require_all'
require_rel 'pieces'

# A class to represent a chess board
class Board
  def initialize(board_array = nil, prev_board_array = nil)
    @board_array = board_array || create_board_array
    @prev_board_array = prev_board_array
  end

  def update(move)
    new_board_array = @board_array.map(&:dup)

    remove_piece(new_board_array, move)
    move_pieces(new_board_array, move)

    Board.new(new_board_array, @board_array)
  end

  def remove_piece(array, move)
    return unless move.removed

    y, x = move.removed
    array[y][x] = nil
  end

  def move_pieces(array, move)
    move.moved.each do |piece_pos, new_pos|
      move_piece(array, piece_pos, new_pos)
    end
  end

  def move_piece(array, piece_pos, new_pos)
    y, x = piece_pos
    piece = array[y][x]
    array[y][x] = nil

    y, x = new_pos
    array[y][x] = piece
  end

  def create_board_array
    array = Array.new(8) { Array.new(8) }

    array[0] = pieces_array('black')
    array[1] = pawn_array('black')

    array[6] = pawn_array('white')
    array[7] = pieces_array('white')

    array
  end

  def pieces_array(color)
    array = []

    array.concat(side_pieces(color))
    array.push(Queen.new(color))
    array.push(King.new(color))

    array.concat(side_pieces(color).reverse)
  end

  def side_pieces(color)
    array = Array.new(3)

    array[0] = Rook.new(color)
    array[1] = Knight.new(color)
    array[2] = Bishop.new(color)

    array
  end

  def pawn_array(color)
    Array.new(8) { Pawn.new(color) }
  end
end