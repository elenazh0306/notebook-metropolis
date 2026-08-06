class AddTileMapToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :tile_map, :string, array: true, default: []
  end
end
