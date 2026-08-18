class AddXToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :x, :integer
  end
end
