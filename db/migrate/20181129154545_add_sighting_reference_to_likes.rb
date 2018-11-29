class AddSightingReferenceToLikes < ActiveRecord::Migration[5.2]
  def change
    add_reference :likes, :sighting, foreign_key: true
  end
end
