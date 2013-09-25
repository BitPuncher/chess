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
    return unless valid_move?(start_pos, end_pos)

    moving_piece = piece_at(start_pos)

    @grid[end_pos[0]][end_pos[1]] = moving_piece
    @grid[start_pos[0]][start_pos[1]] = nil

    moving_piece.moved if moving_piece.is_a?(Pawn)
  end

  def valid_move?(start_pos, end_pos)
    piece = piece_at(start_pos)
    return false unless piece

    unless piece.moves(start_pos).include?(end_pos)
      raise "That's not within the piece's move range!"
    end

    if blocked?(start_pos, end_pos)
      puts "That move is blocked, try again!"
    end

    true
  end

  def blocked?(start_pos, end_pos)
    piece = piece_at(start_pos)

    return true if destination_is_friendly?(piece, end_pos)

    if piece.is_a?(Pawn)
      # future helper method to check if pawn attack ranges are valid
      @grid[end_pos[0]][end_pos[1]] # this might allow a pawn on its first move to hop
    elsif piece.is_a?(SlidingPiece)
      are_pieces_between?(piece, end_pos)
    else
      false
    end
  end

  def destination_is_friendly?(moving_piece, end_pos)
    occupant = piece_at(end_pos)
    occupant && occupant.color == moving_piece.color
  end

  def are_pieces_between?(start_pos, end_pos)
    points_between(start_pos, end_pos).any? { |position| position }
  end

  def points_between(start_pos, end_pos)

    # prob can be refactored
    # just find range from 0 to change.abs and then map by change/change.abs

    x_change = end_pos[0] - start_pos[0]
    y_change = end_pos[1] - start_pos[1]

    y_range = (-(y_change.abs)..y_change.abs).to_a
    if y_change < 0
      y_range.select! { |y| y < 0 }.reverse!
    else
      y_range.select! { |y| y > 0 }
    end

    x_range = (-(x_change.abs)..x_change.abs).to_a
    if x_change < 0
      x_range.select! { |x| x < 0 }.reverse!
    else
      x_range.select! { |x| x > 0 }
    end


    distances = []
    [x_range.length, y_range.length].max.times do |index|
      x_val = x_range[index] || 0
      y_val = y_range[index] || 0

      distances << [x_val, y_val]
    end

    distances[0..-2].map do |distance|
      [distance[0] + start_pos[0], distance[1] + start_pos[1]]
    end
  end

  def place_board
    @grid[0] = back_row("black")
    @grid[1] = pawn_row("black")
    @grid[6] = pawn_row("white")
    @grid[7] = back_row("white")

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

  def show_board
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