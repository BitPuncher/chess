require './piece'

class Pawn < Piece
  attr_accessor :moved
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

  def duplicate
    pawn = self.class.new(@color)
    pawn.moved = @moved
    pawn
  end

  def move_dir
    vectors = [[1 * @facing, 0]]
    vectors << [2 * @facing, 0] if @moved_yet == false
    if @color == :white
      vectors << [-1, -1]
      vectors << [-1, 1]
    else
      vectors << [1, -1]
      vectors << [1, 1]
    end
    vectors
  end

end