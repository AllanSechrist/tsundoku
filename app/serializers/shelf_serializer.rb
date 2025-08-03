class ShelfSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :created_at

  has_many :shelf_books
  has_many :owned_books
end
