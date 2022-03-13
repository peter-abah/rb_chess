# frozen_string_literal: true

require 'require_all'
require_relative 'board'
require_rel 'game_modules'

# A class to handle a chess game
class Game
  include MoveGenerator
  include MoveParser

  attr_reader :board, :history

  def initialize(fen: nil)
    @board = Board.new(fen_notation: fen)
    @history = [].freeze
    @repetitions_count = Hash.new(0) # for threefold repetition rule
  end
  
  def make_move(move)
    raise StandardError, 'Game over' if game_end?
 
    move = parse_move move
    raise ArgumentError, 'Cannot make move king in check' unless legal_move? move

    board = board.make_move move
    history = [*history, move].freeze
    update_repetitions_count
  end
  
  def all_moves
    board.player_pieces(current_player).reduce([]) do |moves, piece|
      moves.concat moves_for_piece(piece).map(&:to_s)
    end
  end
  
  def moves_at(pos)
    moves_for_pos(pos).map(&:to_s)
  end
  
  def current_player
    board.active_color
  end
  
  def stalemate?
    all_moves.empty?
  end
  
  def threefold?
    repetitions_count.values.any? { |e| e >= 3 }
  end
  
  def fivefold?
    repetitions_count.values.any? { |e| e >= 5 }
  end
  
  def seventy_five_moves?
    board.halfmove_count >= 150
  end
  
  def fifty_moves?
    board.halfmove_count >= 100
  end
  
  def checkmate?
    stalemate? && check?
  end
  
  def insufficient_material?
    return true if board.pieces.size == 2 # only kings
    
    return true if board.pieces.size == 3 && 
      board.pieces.any? { |p| p.is_a?(Knight) || p.is_a?(Bishop) }
      
    if board.pieces.size == 4
      bishops = board.pieces.select { |p| p.is_a? Bishop }
      return bishops.length == 2 && 
        bishops[0].position.square_type == bishops[1].position.square_type
    end
    
    return false
  end

  def draw?
    stalemate? || fivefold? || insufficient_material? || seventy_five_moves?
  end
  
  def game_over?
    checkmate? || draw?
  end
  
  private
  
  def update_repetitions_count
    # removes halfmove and fullmove since they are needed
    board_fen = board.to_fen.split(' ').first(4).join(' ')
    repetitions_count[board_fen] = repetitions_count[board_fen] + 1
  end
  
  private
  
  attr_reader :repetitions_count
  attr_writer :history, :board
end

