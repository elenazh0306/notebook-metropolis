class AddHotspotTypeToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :hotspot_type, :string
  end
end
