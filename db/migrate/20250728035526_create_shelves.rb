class CreateShelves < ActiveRecord::Migration[7.1]
  def change
    create_table :shelves do |t|
      t.string :title
      t.text :description
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
