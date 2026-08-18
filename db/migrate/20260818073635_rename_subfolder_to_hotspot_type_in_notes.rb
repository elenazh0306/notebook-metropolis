class RenameSubfolderToHotspotTypeInNotes < ActiveRecord::Migration[8.1]
  def change
    rename_column :notes, :subfolder, :hotspot_type
  end
end
