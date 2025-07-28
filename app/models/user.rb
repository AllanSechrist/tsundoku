class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_one :profile
  has_many :members, dependent: :destroy
  has_many :bookclubs, foreign_key: :creator_id, dependent: :destroy # maybe change to nullify in future?

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
