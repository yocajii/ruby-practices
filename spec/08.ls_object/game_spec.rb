# frozen_string_literal: true

require_relative '../../08.ls_object/game'

RSpec.describe Game do
  describe '#point' do
    example 'ボウリングプラクティスのページに例示されたゲームの得点が返ること' do
      game1 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
      game2 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
      game3 = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
      game4 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
      game5 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
      game6 = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')

      aggregate_failures do
        expect(game1.point).to eq 139
        expect(game2.point).to eq 164
        expect(game3.point).to eq 107
        expect(game4.point).to eq 134
        expect(game5.point).to eq 144
        expect(game6.point).to eq 300
      end
    end
  end
end
