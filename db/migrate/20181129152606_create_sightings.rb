class CreateSightings < ActiveRecord::Migration[5.2]
  def change
    create_table :sightings do |t|
      t.integer :logitude
      t.integer :latitude
      t.string :image

      t.timestamps
    end
  end
end
