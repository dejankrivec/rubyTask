require 'faker'

FactoryBot.define do
    factory :like do |f|
      f.user_id { Faker::Number.number(1) }
      f.sighting_id { Faker::Number.number(1) }
      f.likes 0
    end
  end