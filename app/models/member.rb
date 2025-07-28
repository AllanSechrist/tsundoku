class Member < ApplicationRecord
  belongs_to :user
  belongs_to :bookclub
  validates :user_id, uniqueness: { scope: :bookclub_id }
end
