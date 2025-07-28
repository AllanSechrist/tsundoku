class CreateOwnedBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :owned_books do |t|
      t.string :rating
      t.text :review
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      # an owned book does not need to have a shelf.
      t.references :shelf, null: true, foreign_key: true

      t.timestamps
    end
  end
end
