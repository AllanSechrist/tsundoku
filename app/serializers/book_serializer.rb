class BookSerializer
  include JSONAPI::Serializer
  attributes :title

  belongs_to :author
  belongs_to :publisher
  belongs_to :genre
  has_many :owned_books
end
