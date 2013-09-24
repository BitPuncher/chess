require './king.rb'
require './queen.rb'
require './rook.rb'
require './knight.rb'
require './bishop.rb'
require './pawn.rb'

class Board
  attr_accessor :grid
  BACK_PIECES = {1 => "Rook", 2 => "Knight", 3 => "Bishop", 4 => "King",
                5 => "Queen", 6 => "Bishop", 7 => "Knight", 8 => "Rook" }

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def move(start_pos, end_pos)
    @grid[end_pos[0]][end_pos[1]] = @grid[start_pos[0]][start_pos[1]]
    @grid[start_pos[0]][start_pos[1]] = nil
  end

  def place_board
    @grid[0] = back_row(0, :black)
    @grid[1] = pawn_row(1, :black)
    @grid[6] = pawn_row(6, :white)
    @grid[7] = back_row(7, :white)
  end

  def back_row(row, color)
    (1..8).map do |x_value|
      eval(BACK_PIECES[x_value]).new([x_value - 1, row], color)
    end
  end

  def pawn_row(row, color)
    (1..8).map do |x_value|
      Pawn.new([x_value - 1, row], color)
    end
  end


end