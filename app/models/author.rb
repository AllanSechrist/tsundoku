class Author < ApplicationRecord
  has_many :books, dependent: :nullify
end
