class OwnedBookSerializer
  include JSONAPI::Serializer
  attributes :rating, :review, :book_id
  belongs_to :book
  belongs_to :user
  has_many :shelf_books
  has_many :shelves
end
