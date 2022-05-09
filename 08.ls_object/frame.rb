# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  attr_reader :shots

  def spare?
    @shots.size == 2 && @shots.sum == 10 ? true : false
  end

  def strike?
    @shots.size == 1
  end
end
