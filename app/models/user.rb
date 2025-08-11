class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_one :profile, dependent: :destroy
  has_many :shelves, through: :profile
  has_many :memberships, class_name: "Member", dependent: :destroy
  has_many :member_bookclubs, through: :memberships, source: :bookclub #user.member_bookclubs
  has_many :created_bookclubs, class_name: "Bookclub", foreign_key: :creator_id, dependent: :nullify
  has_many :owned_books, dependent: :destroy
  has_many :books, through: :owned_books
  has_many :sent_invites, class_name: "Invite", foreign_key: :sender_id, dependent: :destroy
  has_many :received_invites, class_name: "Invite", foreign_key: :recipient_id, dependent: :nullify

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  after_create :build_default_profile

  private

  def build_default_profile
    # creates profile automatically for user
    create_profile! unless profile
  end
end
