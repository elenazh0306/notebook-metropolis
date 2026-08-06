class CreateCitizens < ActiveRecord::Migration[8.1]
  def change
    create_table :citizens do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
