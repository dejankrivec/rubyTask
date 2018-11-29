class AddFlowerReferenceToSightings < ActiveRecord::Migration[5.2]
  def change
    add_reference :sightings, :flower, foreign_key: true
  end
end
