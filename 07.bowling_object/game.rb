# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score)
    @score = score
  end

  def point
    frames = convert_to_frames(@score)
    frames.map(&:point).sum
  end

  private

  def convert_to_frames(score)
    scores = score.split(',').flat_map { |s| s == 'X' ? [10, nil] : s.to_i }
    pairs = scores.each_slice(2).to_a
    (pairs[0..8] << pairs[9..].flatten)
      .map(&:compact)
      .concat([[0], [0]]) # each_consのためのダミーフレームを末尾に追加
      .each_cons(3)
      .map { |three_sets| Frame.new(*three_sets) }
  end
end
