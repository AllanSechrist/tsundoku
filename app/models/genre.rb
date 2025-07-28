class Genre < ApplicationRecord
  has_many :books, dependent: :nullify
end
