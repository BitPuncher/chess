require './piece'

class Pawn < Piece
  attr_reader :moved_yet, :facing

  def initialize(color)
    super(color)
    @moved_yet = false
    if @color == :white
      @facing = -1
    else
      @facing = 1
    end
  end

  def move_dir
    vectors = [[1 * @facing, 0]]
    vectors << [2 * @facing, 0] if @moved_yet == false
    vectors
  end

  def moved
    @moved_yet = true
  end

end