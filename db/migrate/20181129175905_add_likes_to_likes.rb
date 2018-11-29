class AddLikesToLikes < ActiveRecord::Migration[5.2]
  def change
    add_column :likes, :likes, :integer
  end
end
