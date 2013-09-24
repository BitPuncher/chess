require './piece'

class Pawn < Piece
  attr_reader :moved_yet, :facing

  def initialize(position, color)
    super(position, color)
    @moved_yet = false
    if @color == :white
      @facing = -1
    else
      @facing = 1
    end
  end

  def move_dir
    vectors = [[0, 1 * @facing]]
    vectors << [0, 2 * @facing] if @moved_yet == false
    vectors
  end

end