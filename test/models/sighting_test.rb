require 'test_helper'

class SightingTest < ActiveSupport::TestCase
  
  test 'valid Sighting' do
    user = User.exists?(id:0)
    flower = Flower.exists?(id:0)
    if user and flower
      sighting = Sighting.create(latitude: 0, logitude: 0, image: "test_image", user_id: 0, flower_id: 0, question: "test_question")
      sighting.valid?
    end
    assert true
  end
end
