require './sliding_piece.rb'

class Rook < SlidingPiece
  def move_dir
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end