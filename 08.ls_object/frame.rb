# frozen_string_literal: true

class Frame
  def initialize(shots, next_shots, after_next_shots)
    @shots = shots
    @next_shots = next_shots
    @after_next_shots = after_next_shots
  end

  def point
    @shots.sum + point_of_spare + point_of_strike
  end

  private

  def point_of_spare
    if @shots.size == 2 && @shots.sum == 10
      @next_shots.first
    else
      0
    end
  end

  def point_of_strike
    if @shots.size == 1
      [@next_shots, @after_next_shots].flatten.first(2).sum
    else
      0
    end
  end
end
