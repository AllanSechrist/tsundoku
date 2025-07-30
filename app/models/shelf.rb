class Shelf < ApplicationRecord
  belongs_to :profile
  has_many :shelf_books, dependent: :destroy
  has_many :owned_books, through: :shelf_books
  has_many :books, through: :owned_books
end
