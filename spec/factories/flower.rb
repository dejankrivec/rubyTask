FactoryBot.define do
    factory :flower do |f|
      f.name { [*('A'..'Z')].sample(8).join }
      f.image { [*('A'..'Z')].sample(8).join }
      f.description { [*('A'..'Z')].sample(8).join }
    end
  end