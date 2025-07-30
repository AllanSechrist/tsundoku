class OwnedBook < ApplicationRecord
  belongs_to :book
  belongs_to :user
  # an owned book does not need to have a shelf.
  has_many :shelf_book, dependent: :destroy
  has_many :shelves, through: :shelf_books
end
