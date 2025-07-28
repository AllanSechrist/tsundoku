class Bookclub < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :members, dependent: :destroy
  has_many :users, through: :members

  after_create :add_creator_as_member

  private

  def add_creator_as_member
    members.create(user: creator)
  end
end
