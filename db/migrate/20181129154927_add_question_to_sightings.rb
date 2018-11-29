class AddQuestionToSightings < ActiveRecord::Migration[5.2]
  def change
    add_column :sightings, :question, :string
  end
end
