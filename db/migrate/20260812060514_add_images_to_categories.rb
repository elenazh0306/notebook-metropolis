class AddImagesToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :sprite_image, :string
    add_column :categories, :room_image, :string
  end
end
