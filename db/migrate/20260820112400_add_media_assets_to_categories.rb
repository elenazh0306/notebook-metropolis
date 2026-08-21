class AddMediaAssetsToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :room_video, :string
    add_column :categories, :building_animation_type, :string
  end
end
