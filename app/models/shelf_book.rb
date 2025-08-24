class ShelfBook < ApplicationRecord
  # Only joins Shelf with OwnedBooks
  belongs_to :owned_book
  belongs_to :shelf
end
