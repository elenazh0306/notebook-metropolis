class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :summary
      t.integer :x
      t.integer :y
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
