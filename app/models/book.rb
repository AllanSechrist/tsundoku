class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher
  belongs_to :genre
  has_many :owned_books, dependent: :destroy
end
