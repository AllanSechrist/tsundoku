class GenreSerializer
  include JSONAPI::Serializer
  attributes :name
  has_many :books
end
