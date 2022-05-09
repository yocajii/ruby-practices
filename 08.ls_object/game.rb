# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score)
    @score = score
  end

  attr_reader :score

  def point
    @frames = convert(@score)
    point_of_base + point_of_spare + point_of_strike
  end

  private

  def convert(score)
    scores = score.split(',').flat_map { |s| s == 'X' ? [10, nil] : s.to_i }
    pairs = scores.each_slice(2).to_a
    (pairs[0..8] << pairs[9..].flatten)
      .map(&:compact)
      .map do |s|
        Frame.new(s)
      end
  end

  def point_of_base
    @frames.map(&:shots).flatten.sum
  end

  def point_of_spare
    @frames.map.with_index do |f, i|
      @frames[i + 1].shots[0] if f.spare?
    end.compact.sum
  end

  def point_of_strike
    @frames.map.with_index do |f, i|
      @frames[i + 1..i + 2].map(&:shots).flatten.first(2) if f.strike?
    end.flatten.compact.sum
  end
end
