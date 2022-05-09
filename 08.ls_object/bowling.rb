# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'

game = Game.new(ARGV[0])
puts game.point
