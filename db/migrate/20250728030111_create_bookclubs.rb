class CreateBookclubs < ActiveRecord::Migration[7.1]
  def change
    create_table :bookclubs do |t|
      t.string :name
      t.text :description
      # change name of user column to creator.
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
