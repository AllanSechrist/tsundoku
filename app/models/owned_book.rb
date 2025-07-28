class OwnedBook < ApplicationRecord
  belongs_to :book
  belongs_to :user
  belongs_to :shelf, optional: true
end
