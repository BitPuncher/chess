require './king.rb'
require './queen.rb'
require './rook.rb'
require './knight.rb'
require './bishop.rb'
require './pawn.rb'
require 'colorize'

class Board
  attr_accessor :grid
  BACK_PIECES = {1 => "Rook", 2 => "Knight", 3 => "Bishop", 4 => "King",
                5 => "Queen", 6 => "Bishop", 7 => "Knight", 8 => "Rook" }

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  # def [](pos)
  # def []=(pos, val)
  def piece_at(position)
    row = position[0]
    col = position[1]
    @grid[row][col]
  end

  # def piece_at=(position, piece)
  #   row = position[0]
  #   col = position[1]
  #   @grid[row][col] = piece
  # end

  def move(start_pos, end_pos)
    return false unless valid_move?(start_pos, end_pos)

    moving_piece = piece_at(start_pos)

    @grid[end_pos[0]][end_pos[1]] = moving_piece
    @grid[start_pos[0]][start_pos[1]] = nil

    moving_piece.moved if moving_piece.is_a?(Pawn)
    true
  end

  def valid_move?(start_pos, end_pos)
    # @errors
    piece = piece_at(start_pos)
    # raise "There is no piece there."
    return false unless piece

    # raise "That's not within the piece's move range!"
    return false unless piece.moves(start_pos).include?(end_pos)

    if pawn_attack?(start_pos, end_pos)
      # raise "A Pawn can't attack an empty space."
      return false unless piece_at(end_pos)
      # raise "A Pawn can only attack an enemy piece."
      return false if destination_is_friendly?(start_pos, end_pos)
    end

    # raise "That move is blocked, try again!"
    return false if blocked?(start_pos, end_pos)

    true
  end

  def pawn_attack?(start_pos, end_pos)
    return false unless piece_at(start_pos).is_a?(Pawn)
    return false if start_pos[1] == end_pos[1]
    true
  end

  def blocked?(start_pos, end_pos)
    return true if destination_is_friendly?(start_pos, end_pos)

    piece = piece_at(start_pos)

    if piece.is_a?(Pawn)
      # future helper method to check if pawn attack ranges are valid
      @grid[end_pos[0]][end_pos[1]] # this might allow a pawn on its first move to hop
    elsif piece.is_a?(SlidingPiece)
      are_pieces_between?(start_pos, end_pos)
    else
      false
    end
  end

  def in_check?(color)
    king_position = find_king(color)

    (0..7).each do |row|
      (0..7).each do |col|
        return true if piece_at([row, col]).color != color && valid_move?([row, col], king_position)
      end
    end
    false
  end

  def all_valid_moves_of(color)
    valid_moves = []

    (0..7).each do |row|
      (0..7).each do |col|
        piece = piece_at([row, col])
        if piece && piece.color == color
          new_valid_moves = piece.moves([row, col]).select { |move| valid_move?([row, col], move)}
          valid_moves = valid_moves + new_valid_moves
        end
      end
    end

    valid_moves
  end


  def find_king(color)
    (0..7).each do |row|
      (0..7).each do |col|
        piece = piece_at([row, col])
        if piece && piece.is_a?(King) && piece.color == color
          return [row, col]
        end
      end
    end
    false
  end

  def destination_is_friendly?(start_pos, end_pos)
    occupant = piece_at(end_pos)
    occupant && occupant.color == piece_at(start_pos).color
  end

  def are_pieces_between?(start_pos, end_pos)
    points_between(start_pos, end_pos).any? { |position| position }
  end

  def points_between(start_pos, end_pos)

    x_change = end_pos[0] - start_pos[0]
    y_change = end_pos[1] - start_pos[1]

    x_range = zero_to_delta(x_change)
    y_range = zero_to_delta(y_change)

    deltas = build_deltas_from(x_range, y_range)

    deltas.map do |distance|
      [distance[0] + start_pos[0], distance[1] + start_pos[1]]
    end
  end

  def zero_to_delta(change)
    (1...change.abs).to_a.map { |element| element * (change/change.abs) }
  end

  def build_deltas_from(domain, range)
    positions = []
    [domain.length, range.length].max.times do |index|
      x_val = domain[index] || 0
      y_val = range[index] || 0

      positions << [x_val, y_val]
    end
    positions
  end

  def place_board
    @grid[0] = back_row(:black)
    @grid[1] = pawn_row(:black)
    @grid[6] = pawn_row(:white)
    @grid[7] = back_row(:white)

    puts "Board Placed!".red
  end

  def back_row(color)
    (1..8).map do |x_value|
      eval(BACK_PIECES[x_value]).new(color)
    end
  end

  def pawn_row(color)
    (1..8).map do |x_value|
      Pawn.new(color)
    end
  end

  # def to_s
  def show_board
    # board_str = ""
    print "   "
    (1..8).each do |col_num|
      print "|#{col_num}".rjust(4)
    end
    print "\n"

    @grid.each_with_index do |row, index|
      print "#{(index + 1)}|"
      row.each do |piece|
        print (piece ? "| #{piece.display} " : "|   ").ljust(3)
      end
      print "\n"

    end
  end
end