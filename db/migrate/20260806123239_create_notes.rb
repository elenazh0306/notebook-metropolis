class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
