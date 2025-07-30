class FixShelfOwnedBookRelationship < ActiveRecord::Migration[7.1]
  def change
    remove_reference :owned_books, :shelf, foreign_key: true
  end
end
