class Player
  attr_reader :name, :color
  attr_accessor :pieces, :in_check, :castled
  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
    @in_check = false
    @castled = false
    get_pieces
  end

  def show
    @pieces.each {|piece| puts piece.inspect }
  end

  def in_check?
    @in_check == true
  end

  def kill_piece(position)
      @pieces = @pieces.reject{ |piece| piece.position == position }
  end

  def promote_to(figure)
    @promoted_pawn = @pieces.select { |piece| piece.figure == :pawn }.find { |pawn| pawn.promote == true }
    position = @promoted_pawn.position
    kill_piece(position)

    case figure
    when :queen   then  @pieces << Queen.new(@color, position)
    when :rook    then  @pieces << Rook.new(@color, position)
    when :knight  then  @pieces << Knight.new(@color, position)
    when :bishop  then  @pieces << Bishop.new(@color,position)
    end
  end

  def castle(side)

    case side
    when:king
      @pieces.select { |piece| piece.figure == :rook }.find { |rook| rook.side == :king }.position[1] -= 2
      @pieces.find { |piece| piece.figure == :king }.position[1] += 2
    when :queen
      @pieces.select { |piece| piece.figure == :rook }.find { |rook| rook.side == :queen }.position[1] += 3
      @pieces.find { |piece| piece.figure == :king }.position[1] -= 2
    end
  end

  def get_pieces
    case color
      when :white
        for i in 0..7
          @pieces << Pawn.new(:white, [1,i])
        end
          @pieces << Rook.new(   :white, [0,0], :queen)
          @pieces << Rook.new(   :white, [0,7], :king)
          @pieces << Bishop.new( :white, [0,6])
          @pieces << Bishop.new( :white, [0,1])
          @pieces << Knight.new( :white, [0,5])
          @pieces << Knight.new( :white, [0,2])
          @pieces << Queen.new(  :white, [0,3])
          @pieces << King.new(   :white, [0,4])
      when :black
        for i in 0..7
          @pieces << Pawn.new(:black, [6,i])
        end
          @pieces << Rook.new(   :black, [7,0], :queen)
          @pieces << Rook.new(   :black, [7,7], :king)
          @pieces << King.new(   :black, [7,4])
          @pieces << Queen.new(  :black, [7,3])
          @pieces << Knight.new( :black, [7,2])
          @pieces << Knight.new( :black, [7,5])
          @pieces << Bishop.new( :black, [7,1])
          @pieces << Bishop.new( :black, [7,6])
    end
  end
end


