require './piece.rb'

class SlidingPiece < Piece
  def moves
    moves = []
    move_dir.each do |vector|
      (1..7).each do |multiplier|
        move = [position[0] + (vector[0] * multiplier),
                position[1] + (vector[1] * multiplier)]
        moves << move if on_board?(move)
      end
    end

    moves
  end
end

