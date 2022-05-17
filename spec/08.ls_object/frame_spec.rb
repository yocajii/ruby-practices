# frozen_string_literal: true

require_relative '../../08.ls_object/game'
require_relative '../../08.ls_object/frame'

RSpec.describe Frame do
  describe '#point' do
    example 'ボーナスポイント無しの時に素点が返ること' do
      frame = Frame.new([5, 0], [1, 2], [3, 4])
      expect(frame.point).to eq 5
    end

    example 'スペアの時にボーナスポイントを加算した点が返ること' do
      frame = Frame.new([5, 5], [1, 2], [3, 4])
      expect(frame.point).to eq 11
    end

    example 'ストライクの時にボーナスポイントを加算した点が返ること' do
      frame = Frame.new([10], [1, 2], [3, 4])
      expect(frame.point).to eq 13
    end

    example 'ストライクのフレームが連続した時にボーナスポイントを加算した点が返ること' do
      frame = Frame.new([10], [10], [3, 4])
      expect(frame.point).to eq 23
    end
  end
end
