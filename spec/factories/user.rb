require 'faker'

FactoryBot.define do
    factory :user do |f|
      f.email { [*('A'..'Z')].sample(8).join }
      f.username { [*('A'..'Z')].sample(8).join }
      f.password { [*('A'..'Z')].sample(8).join }
    end
end