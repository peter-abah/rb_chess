# frozen_string_literal: true

require_relative './errors'

# a class to represent a position in a chess game
module RbChess
  class Position
    attr_reader :y, :x

    def self.parse(string)
      raise ChessError, 'invalid position' unless /^[a-h][1-8]$/.match string

      x = string[0].ord - 97
      y = 8 - string[1].to_i
      Position.new(y: y, x: x)
    end

    def initialize(y:, x:)
      @y = y
      @x = x
    end

    def to_s
      "#{(97 + x).chr}#{8 - y}"
    end

    def ==(other)
      return false unless other.is_a? Position

      x == other.x && y == other.y
    end

    def increment(y: 0, x: 0)
      Position.new(y: self.y + y, x: self.x + x)
    end

    def square_type
      (y + x).even? ? :light : :dark
    end

    def in_bounds?
      y.between?(0, 7) && x.between?(0, 7)
    end

    def out_of_bounds?
      !in_bounds?
    end

    def starting_pawn_rank?(color)
      (color == :white && y == 6) || (color == :black && y == 1)
    end

    def en_passant_rank?(color)
      (color == :white && y == 4) || (color == :black && y == 3)
    end

    def king_pos?(color)
      y = color == :black ? 0 : 7
      self.y == y && x == 4
    end

    def kingside_rook_pos?(color)
      y = color == :black ? 0 : 7
      self.y == y && x == 7
    end

    def queenside_rook_pos?(color)
      y = color == :black ? 0 : 7
      self.y == y && x.zero?
    end
  end
end
