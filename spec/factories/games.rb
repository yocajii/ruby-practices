# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    score { '1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0' }
    initialize_with { new(score) }
  end
end
