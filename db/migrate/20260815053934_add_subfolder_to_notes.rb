class AddSubfolderToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :subfolder, :string
  end
end
