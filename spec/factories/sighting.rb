require 'faker'

FactoryBot.define do
    factory :sighting do |f|
      f.logitude { Faker::Number.number(5) }
      f.latitude { Faker::Number.number(5) }
      f.image { [*('A'..'Z')].sample(8).join }
      f.user_id :user
      f.flower_id :flower
      f.question { [*('A'..'Z')].sample(20).join }
    end
  end