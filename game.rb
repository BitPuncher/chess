require './board.rb'

class Game
  attr_reader :board, :current_player_color

  def initialize
    @board = Board.new
    @board.place_pieces
    @current_player_color = :white
  end

  def run
    until game_over?
      puts @board

      puts "#{@current_player_color}'s move."

      move_from = prompt_move(:from)
      move_to = prompt_move(:to)
      @board.move(move_from, move_to)
      player = (@current_player_color == :white ? :black : :white)
    end

    if @board.in_checkmate?(@current_player_color)
      "#{@current_player_color} is in checkmate."
    else
      "Stalemate."
    end
  end

  def prompt_move(input)
    print "Where would you like to move #{input}? (e.g. 2,3)"
    gets.chomp.split(',').map { |el| el.to_i }
  end

  def game_over?
    @board.in_checkmate?(@current_player_color) || @board.in_stalemate?(@current_player_color)
  end
end