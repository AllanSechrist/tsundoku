class ShelfBook < ApplicationRecord
  belongs_to :owned_book
  belongs_to :shelf
end
