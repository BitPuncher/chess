class Piece
  attr_accessor :color

  DISPLAY_CODES = {:pawn => 9823, :rook => 9820, :knight => 9822,
                  :bishop => 9821, :king => 9818, :queen => 9819}

  def initialize(color)
    @color = color
  end

  def moves(position)
    moves = move_dir.map do |vector|
      [position[0] + vector[0], position[1] + vector[1]]
    end

    moves.select { |move| on_board?(move) }
  end


  def on_board?(move)
    (0..7).include?(move[0]) && (0..7).include?(move[1])
  end

  def display
    code = DISPLAY_CODES[self.class.to_s.downcase.to_sym]
    #
    # code = DISPLAY_CODES[:knight] if is_a?(Knight)
    # code = DISPLAY_CODES[:rook] if is_a?(Rook)
    # code = DISPLAY_CODES[:queen] if is_a?(Queen)
    # code = DISPLAY_CODES[:king] if is_a?(King)
    # code = DISPLAY_CODES[:bishop] if is_a?(Bishop)
    # code = DISPLAY_CODES[:pawn] if is_a?(Pawn)

    # color == "white" ? [code].pack('U').white : [code].pack('U').blue
    if color == :white
      [code].pack('U').white
    else
      [code].pack('U').blue
    end
  end
end




