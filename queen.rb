require './sliding_piece.rb'

class Queen < SlidingPiece
  def move_dir
    [[1, -1], [1, 1], [1, 0], [-1, 1], [-1, -1], [-1, 0], [0, 1], [0, -1]]
  end
end