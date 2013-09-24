require './sliding_piece.rb'

class Bishop < SlidingPiece
  def move_dir
    [[1, -1], [1, 1], [-1, 1], [-1, -1]]
  end
end