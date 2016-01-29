require_relative './pieces.rb'
require_relative './player.rb'
require_relative './board.rb'
require 'colorize'

class Chess
  attr_reader :plr1, :plr2, :board, :all_pieces
  def initialize
    make_players
    make_board
    @all_pieces = plr1.pieces + plr2.pieces
    # update_board
  end

  def play

  end

  def player_move
    puts "Enter your move [ to move from A1 to A2 type: A1 A2 ]"
    input = "70 34"
    input = input.split

    from = input[0].split("").collect!(&:to_i)
    to = input[1].split("").collect!(&:to_i)

    @selected_from = @board.value[from[0]][from[1]]
    @selected_to = @board.value[to[0]][to[1]]

    puts "from: #{@selected_from}, to: #{@selected_to}"

  end

  def make_players
    @plr1 = Player.new('Tomasz', :white)
    @plr2 = Player.new('Piotr', :black)
  end

  def make_board
    @board = Board.new
  end

  def draw_board
    @board.draw
  end

  def update_board
    @board.update(@all_pieces)
  end

end




