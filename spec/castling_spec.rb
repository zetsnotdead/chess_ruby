require_relative '../lib/chess.rb'


describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }
  let(:active_player) {game.active_player}
  let(:update) {game.implement_changes}

  describe '#can_castle?' do
    it 'returns false when the game starts' do
      expect(game.can_castle?).to eql false
    end

    context 'on empty board' do
      it 'returns true with just king and rook' do
        active_player.pieces = [ King.new(:white, [0,4]), Rook.new(:white, [0,7], :king) ]
        update
        expect(game.can_castle?).to eql true
      end
      it 'returns false when king moved' do
        king = King.new(:white, [0,4])
        king.instance_variable_set(:@moved, true)
        active_player.pieces  = [ Rook.new(:white, [0,7], :king), king ]
        update
        expect(game.can_castle?).to eql false
      end
      it 'returns false when rook moved' do
        rook = Rook.new(:white, [0,7], :king)
        rook.instance_variable_set(:@moved, true)
        active_player.pieces = [ King.new(:white, [0,4]), rook ]
        update
        expect(game.can_castle?).to eql false
      end
      it 'returns false wtih piece inbetween' do
        active_player.pieces = [ King.new(:white, [0,4]), Pawn.new(:white, [0,5]), Rook.new(:white, [0,7], :king) ]
        update
        expect(game.can_castle?).to eql false
      end
    end

  end

end