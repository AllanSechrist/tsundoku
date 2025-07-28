class Shelf < ApplicationRecord
  belongs_to :profile
  has_many :owned_books
end
