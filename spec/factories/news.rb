# frozen_string_literal: true

FactoryBot.define do
  factory :news do
    title { FFaker::LoremRU.sentence }
    text { FFaker::LoremRU.sentence }
  end
end
