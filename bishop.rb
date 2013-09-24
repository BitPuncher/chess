require './sliding_piece.rb'

class Bishop < Sliding
  def move_dir
    [[1, -1], [1, 1], [-1, 1], [-1, -1]]
  end
end