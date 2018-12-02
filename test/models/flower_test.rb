require 'test_helper'

class FlowerTest < ActiveSupport::TestCase
  test 'valid Flower' do
    flower = Flower.new(name: 'test_name', image: 'test_image', description: "test_description")
    assert flower.valid?
  end
end
