class Profile < ApplicationRecord
  belongs_to :user
  has_many :shelves, dependent: :destroy
end
