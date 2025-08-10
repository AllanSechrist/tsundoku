class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_one :profile, dependent: :destroy
  has_many :shelves, through: :profile
  has_many :memberships, class_name: "Member", dependent: :destroy
  has_many :bookclubs, foreign_key: :creator_id, dependent: :destroy # maybe change to nullify in future?
  has_many :owned_books, dependent: :destroy
  has_many :books, through: :owned_books
  has_many :invites, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def get_memberships
    # returns a list of bookclub names that the user is in.
    memberships.map { |membership| membership.bookclub.name }
  end
end
