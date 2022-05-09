# frozen_string_literal: true

require_relative '../../08.ls_object/game'
require_relative '../../08.ls_object/frame'

RSpec.describe Frame do
  let(:basic) { build :frame, shots: [2, 3] }
  let(:spare) { build :frame, shots: [4, 6] }
  let(:strike) { build :frame, shots: [10] }

  example 'スペアの判定' do
    expect(basic.spare?).to be false
    expect(spare.spare?).to be true
  end

  example 'ストライクの判定' do
    expect(basic.strike?).to be false
    expect(strike.strike?).to be true
  end
end
