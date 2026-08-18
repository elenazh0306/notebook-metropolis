class AddYToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :y, :integer
  end
end
