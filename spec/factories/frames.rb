# frozen_string_literal: true

FactoryBot.define do
  factory :frame do
    shots { [1, 0] }
    initialize_with { new(shots) }
  end
end
