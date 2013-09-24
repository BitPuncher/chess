class Piece
  :position, :color

  def initialize(position, color)
    @position = position
    @color = color
  end

  def moves
    move_dir.map do |vector|
      [position[0] + vector[0], position[1] + vector[1]]
    end
  end

end




