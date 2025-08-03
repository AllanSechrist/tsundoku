class ShelfBookSerializer
  include JSONAPI::Serializer
  attributes :id
  belongs_to :owned_book
  belongs_to :shelf
end
