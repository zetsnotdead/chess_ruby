module Castling
  def can_castle?
    check = @active_player.in_check?
    king_moved = @active_player.pieces.find { |piece| piece.figure == :king }.moved
    @can_castle_queenside = queenside_space_empty? && !queenside_rook_moved? && !queenside_under_attack
    @can_castle_kingside = kingside_space_empty? && !kingside_rook_moved? && !kingside_under_attack
    @can_castle_both_ways = @can_castle_queenside && @can_castle_kingside

    !check && !king_moved && (@can_castle_queenside || @can_castle_kingside)
  end

  def queenside_space_empty?
    case @active_player.color
    when :black
      @board.empty_field?([7,1]) && @board.empty_field?([7,2]) && @board.empty_field?([7,3])
    when :white
      @board.empty_field?([0,1]) && @board.empty_field?([0,2]) && @board.empty_field?([0,3])
    end
  end

  def kingside_space_empty?
    case @active_player.color
    when :black
      @board.empty_field?([7,5]) && @board.empty_field?([7,6])
    when :white
      @board.empty_field?([0,5]) && @board.empty_field?([0,6])
    end
  end

  def queenside_rook_moved?
    rook = @active_player.pieces.find_all { |piece| piece.figure == :rook }.find { |rook| rook.side == :queen }
    return true if rook == nil
    rook.moved
  end

  def kingside_rook_moved?
    rook = @active_player.pieces.find_all { |piece| piece.figure == :rook }.find { |rook| rook.side == :king }
    return true if rook == nil
    rook.moved
  end

  def queenside_under_attack
    @opposing_player.pieces.each { |piece| piece.receive_environment(@opposing_player, @active_player) }
    fields_under_attack = @opposing_player.pieces.collect { |piece| piece.find_possible_moves }.flatten(1)
    case @active_player.color
    when :black
      @under_attack = fields_under_attack.any? { |i| [[7,2], [7,3], [7,4]].include? i }
    when :white
      @under_attack = fields_under_attack.any? { |i| [[0,2], [0,3], [0,4]].include? i }
    end
    @under_attack
  end

  def kingside_under_attack
    @opposing_player.pieces.each { |piece| piece.receive_environment(@opposing_player, @active_player) }
    fields_under_attack = @opposing_player.pieces.collect { |piece| piece.find_possible_moves }.flatten(1)

    case @active_player.color
    when :black
      @under_attack = fields_under_attack.any? { |i| [[7,5], [7,6], [7,4]].include? i }
    when :white, [7,4]
      @under_attack = fields_under_attack.any? { |i| [[0,5], [0,6], [0,4]].include? i }
    end
    @under_attack
  end
end