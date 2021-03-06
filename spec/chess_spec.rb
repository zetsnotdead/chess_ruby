require_relative '../lib/chess.rb'

describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }
  let(:update) {
                  game.collect_all_pieces
                  game.update_board
                  # game.draw_board
                }

    describe Pawn do

      context 'when moving' do
        before do
          @pawn = Pawn.new(:white, [1,1])
        end
          it { expect{ @pawn.position=[2,1] }.to change{@pawn.position}.from([1,1]).to([2,1]) }
          it { expect{ @pawn.position=[2,1] }.to change{@pawn.moved}.from(false).to(true) }

          it 'to a square occupied by an ally' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,1])
            pawn = Pawn.new(:white, [1,1])
            pawn.receive_environment(plr1, plr2)
            expect{ pawn.find_possible_moves }.to change{ pawn.possible_moves.size }.from(0).to(1)
          end

          it 'to a square occupied by an ally' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [2,1])
            pawn = Pawn.new(:white, [1,1])
            pawn.receive_environment(plr1, plr2)
            expect{ pawn.find_possible_moves }.to_not change{ pawn.possible_moves.size }
          end

      end

      context 'testing if [6,2] can move diagonally to kill [5,1]' do

        before do
          plr1.pieces << Pawn.new(:white, [5,1] )
          update
          @killer = plr2.pieces.select { |piece| piece.position == [6,2] }.first
          @killer.receive_environment(plr2, plr1)
          @killer.find_possible_moves
        end

        it 'adds an extra move when possible to kill another piece' do
          expect(@killer.possible_moves).to match_array([[5,1], [4,2], [5,2]])
        end
      end

      context 'testing if [1,1] can move diagonally to kill [2,2]' do
        before do
          plr2.pieces << Pawn.new(:black, [2,2] )
          update
          @killer = plr1.pieces.select { |piece| piece.position == [1,1] }.first
          @killer.receive_environment(plr1, plr2)
          @killer.find_possible_moves
        end

        it 'adds an extra move when possible to kill another piece' do
          expect(@killer.possible_moves).to match_array([[2,2], [3,1], [2,1]])
        end
      end
    end

    describe Knight do
      context 'when moving on empty board' do
        before do
            plr1.pieces = []
            plr2.pieces = []
        end
          it 'middle' do
            knight = Knight.new(:white, [4,4])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(8)
          end
          it 'middle left' do
            knight = Knight.new(:white, [7,4])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it 'middle bottom' do
            knight = Knight.new(:white, [0,4])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it 'middle right' do
            knight = Knight.new(:white, [4,7])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it 'top right' do
            knight = Knight.new(:white, [7,4])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it 'bottom left corner' do
            knight = Knight.new(:white, [0,0])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it 'top right corner' do
            knight = Knight.new(:white, [7,7])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it 'bottom right corner' do
            knight = Knight.new(:white, [0,7])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it 'top left corner' do
            knight = Knight.new(:white, [7,0])
            plr1.pieces << knight
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
        end

       context 'when finding possible moves, reacts to the presence of ally pieces' do
          it 'two deep bottom' do
            plr2.pieces = []
            knight = Knight.new(:white, [3,3])
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(6)
          end
          it 'two bottom' do
            plr2.pieces = []
            knight = Knight.new(:white, [2,3])
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it do 'upper left deep'
            plr2.pieces = []
            knight = Knight.new(:white, [2,3])
            plr1.pieces << Bishop.new(:white, [3,1])
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(3)
          end

          it do 'upper left'
            plr2.pieces = []
            knight = Knight.new(:white, [2,3])
            plr1.pieces << Bishop.new(:white, [3,1]) << Bishop.new(:white, [4,2])
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it 'upper right' do
            plr2.pieces = []
            knight = Knight.new(:white, [2,3])
            plr1.pieces << Bishop.new(:white, [3,1]) << Bishop.new(:white, [4,2]) << Bishop.new(:white, [4,4])
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(1)
          end

          it 'upper right deep' do
            plr2.pieces = []
            knight = Knight.new(:white, [2,3])
            plr1.pieces << Bishop.new(:white, [3,1]) << Bishop.new(:white, [4,2]) << Bishop.new(:white, [4,4]) << Bishop.new(:white, [3,5])
            knight.receive_environment(plr1, plr2)
            expect{ knight.find_possible_moves }.to_not change{ knight.possible_moves.size }
          end

      end
    end

    describe Rook do
     context 'when moving on empty board' do
        before do
          plr1.pieces = []
          plr2.pieces = []
        end
          it do
            rook = Rook.new(:white, [0,0])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [7,7])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [0,7])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [7,0])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [0,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [4,0])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [7,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [4,7])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
        end

        context 'when finding possible moves, reacts to the presence of ally pieces' do
          it 'down' do
            plr2.pieces = []
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 3 up, 7 left+right, 2 down

          end

          it 'up' do
            plr1.pieces = []
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr2, plr1)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 2 up, 7 left+right, 3 down
          end

          it 'left' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [4,3])
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(10) # 3 up, 4 down, 0 left, 2 right
          end

          it 'right' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [4,5])
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(11) # 3 up, 4 down, 4 left, 0 right
          end
        end

        context 'when finding possible moves, reacts to the presence of enemy pieces' do
          before do
            plr1.pieces = []
            plr2.pieces = []
          end
          it 'down' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [4,3]) << Pawn.new(:black, [4,2])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(11) # 3 up, 7 left+right, 1 down
          end

          it 'up' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [4,5]) << Pawn.new(:black, [4,6])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 1 up, 7 left+right, 4 down
          end

          it 'left' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [2,4]) << Pawn.new(:black, [3,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(11) #  7 up and down, 1 left, 3 right
          end

          it 'right' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [5,4]) << Pawn.new(:black, [6,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 7 up and down, 4 left, 1 right
          end
        end
    end

    describe Bishop do
      context 'when moving on empty board' do
        before do
          plr1.pieces = []
          plr2.pieces = []
        end

          it do
            bishop = Bishop.new(:white, [0,0])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [7,7])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [0,7])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [7,0])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [0,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [4,0])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [7,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [4,7])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(13)
          end
        end

        context 'when finding possible moves, reacts to the presence of ally pieces' do
          it 'down' do
            plr2.pieces = []
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(10)

          end

          it 'up' do
            plr1.pieces = []
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr2, plr1)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(9)
          end

          it 'left-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,3])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(9)
          end

          it 'right-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,5])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(10)
          end
          it 'left-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,3])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(10)
          end
          it 'right-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,5])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(10)
          end
        end

        context 'when finding possible moves, reacts to the presence of enemy pieces' do
          before do
            plr1.pieces = []
            plr2.pieces = []
          end
          it 'left-down' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,3]) << Pawn.new(:black, [2,2])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(10)
          end

          it 'left-up' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,5]) << Pawn.new(:black, [2,6])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(11)
          end

          it 'right-up' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [5,5]) << Pawn.new(:black, [6,6])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(11)
          end

          it 'right-down' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,5]) << Pawn.new(:black, [2,6])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(11)
          end
        end
    end

    describe King do
      context 'when moving on empty board' do
        before do
          plr1.pieces = []
          plr2.pieces = []
        end

          it do
            king = King.new(:white, [0,0])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(3)
          end
          it do
            king = King.new(:white, [7,7])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(3)
          end
          it do
            king = King.new(:white, [0,7])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(3)
          end
          it do
            king = King.new(:white, [7,0])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(3)
          end
          it do
            king = King.new(:white, [0,4])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(5)
          end
          it do
            king = King.new(:white, [4,0])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(5)
          end
          it do
            king = King.new(:white, [7,4])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(5)
          end
          it do
            king = King.new(:white, [4,7])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(5)
          end
        end

        context 'when finding possible moves, reacts to the presence of ally pieces' do
          it 'down' do
            plr2.pieces = []
            king = King.new(:white, [2,2])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(5)

          end

          it 'up' do
            plr1.pieces = []
            king = King.new(:white, [5,5])
            king.receive_environment(plr2, plr1)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(5)
          end

          it 'left-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,3])
            king = King.new(:white, [4,4])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(7)
          end

          it 'right-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,5])
            king = King.new(:white, [4,4])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(7)
          end
          it 'left-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,3])
            king = King.new(:white, [4,4])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(7)
          end
          it 'right-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,5])
            king = King.new(:white, [4,4])
            king.receive_environment(plr1, plr2)
            expect{ king.find_possible_moves }.to change{ king.possible_moves.size }.from(0).to(7)
          end
        end
    end

    describe Queen do
      context 'when moving on empty board' do
        before do
          plr1.pieces = []
          plr2.pieces = []
        end
        it do
            queen = Queen.new(:white, [4,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(27)
          end
        it do
            queen = Queen.new(:white, [0,0])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
          it do
            queen = Queen.new(:white, [7,7])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
          it do
            queen = Queen.new(:white, [0,7])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
          it do
            queen = Queen.new(:white, [7,0])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
          it do
            queen = Queen.new(:white, [0,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
          it do
            queen = Queen.new(:white, [4,0])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
          it do
            queen = Queen.new(:white, [7,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
          it do
            queen = Queen.new(:white, [4,7])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end
        end

      context 'when finding possible moves, reacts to the presence of ally pieces' do
          it 'down' do
            plr2.pieces = []
            queen = Queen.new(:white, [4,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(22)
          end

          it 'up' do
            plr1.pieces = []
            queen = Queen.new(:white, [4,4])
            queen.receive_environment(plr2, plr1)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(21)
          end

          it 'left-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,3])
            queen = Queen.new(:white, [4,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(23)
          end

          it 'right-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,5])
            queen = Queen.new(:white, [4,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(24)
          end
          it 'left-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,3])
            queen = Queen.new(:white, [4,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(24)
          end
          it 'right-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,5])
            queen = Queen.new(:white, [4,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(24)
          end
        end

        context 'when finding possible moves, reacts to the presence of enemy pieces' do
          before do
            plr1.pieces = []
            plr2.pieces = []
          end
          it 'left-down' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,3]) << Pawn.new(:black, [2,2])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(24)
          end

          it 'left-up' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,5]) << Pawn.new(:black, [2,6])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(25)
          end

          it 'right-up' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [5,5]) << Pawn.new(:black, [6,6])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(25)
          end

          it 'right-down' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,5]) << Pawn.new(:black, [2,6])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(25)
          end


          it 'down' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,4]) << Pawn.new(:black, [2,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(24)
          end


          it 'up' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [5,4]) << Pawn.new(:black, [6,4])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(25)
          end


          it 'left' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [4,3]) << Pawn.new(:black, [4,2])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(24)
          end



          it 'right' do
            plr1.pieces <<  queen = Queen.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [4,5]) << Pawn.new(:black, [4,6])
            queen.receive_environment(plr1, plr2)
            expect{ queen.find_possible_moves }.to change{ queen.possible_moves.size }.from(0).to(25)
          end
        end
      end
end