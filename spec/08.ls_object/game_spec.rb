# frozen_string_literal: true

require_relative '../../08.ls_object/game'
require_relative '../../08.ls_object/frame'

RSpec.describe Game do
  let(:game1) { build :game, score: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5' }
  let(:game2) { build :game, score: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X' }
  let(:game3) { build :game, score: '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4' }
  let(:game4) { build :game, score: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0' }
  let(:game5) { build :game, score: '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8' }
  let(:game6) { build :game, score: 'X,X,X,X,X,X,X,X,X,X,X,X' }

  example 'ゲームの得点が返ってくる' do
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
