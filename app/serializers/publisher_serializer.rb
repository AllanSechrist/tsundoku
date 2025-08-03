class PublisherSerializer
  include JSONAPI::Serializer
  attributes :name
  has_many :books
end
