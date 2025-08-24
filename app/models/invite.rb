class Invite < ApplicationRecord
  # holds invites for users to join bookclubs.
  #
  belongs_to :bookclub
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User", optional: true

  enum status: { pending: 0, accepted: 1, declined: 2, expired: 3, revoked: 4 }

  validates :bookclub, :sender, :status, :token, presence: true
  validates :token, uniqueness: true

  # only one pending invite per recipient
  validates :recipient_id, uniqueness: { scope: :bookclub_id, conditions: -> { where(status: statuses[:pending]).where.not(recipient_id: nil) } }, allow_nil: true
  validates :recipient_email, uniqueness: { scope: :bookclub_id, conditions: -> { where(status: statuses[:pending]).where.not(recipient_email: nil) } }, allow_nil: true

  before_validation :normalize_email
  before_validation :generate_token, on: :create
  before_validation :set_default_expiry, on: :create


  # Pre defines search conditions for easier use
  # i.e. Invite.active will return active invites.
  # They can also be chained together: Invite.active.for_bookclub(bookclub_id).pending(current_user)
  scope :active, -> { pending.where("expires_at IS NULL OR expires_at > ?", Time.current)}
  scope :for_bookclub, ->(club_id) {where(bookclub_id: club_id)}
  scope :pending_for, ->(user) {
    where(status: statuses[:pending]).where("recipient_id = :id OR LOWER(recipient_email) = LOWER(:email)", id: user.id, email: user.email)
  }

  def accept!(by_user: nil)
    # Checks if an invite is still valid and adds the user to the bookclubs members list.
    # with_lock ensures that the transaction can only happen once if for some reason
    # the accept method is triggered multiple times.
    with_lock do
      return self if accepted?
      raise "Invite expired" if expired? || (expires_at && expires_at <= Time.current)
      raise "Invite revoked" if revoked?
      raise "Invite not pending" unless pending?

      if recipient_id.present? && by_user && by_user.id != recipient_id
        raise "Not authorized to accept this invite"
      end

      update!(status: :accepted, accepted_at: Time.current, responded_at: Time.current)
      bookclub.members.find_or_create_by!(user_id: (recipient_id || by_user&.id))
    end
  end

  def decline!
    with_lock do
      return self if declined?
      raise "Invite not pending" unless pending?
      update!(status: :declined, declined_at: Time.current, responded_at: Time.current)
    end
  end

  def revoke!
    with_lock do
      return self if revoked?
      raise "Invite not pending" unless pending?
      update!(status: :revoked, responded_at: Time.current)
    end
  end

  def attach_to_user!(user)
    # If the invite doesn't already have a recipient_id, and the recipient_email matches the user's email,
    # attach the user to the invite.
    return self if recipient_id.present?
    if recipient_email.present? && recipient_email.casecmp?(user.email)
      update!(recipient_id: user.id)
    else
      self
    end
  end

  private

  def normalize_email
    # Ensures that all emails have the same format, no spaces and sets it to null if empty.
    self.recipient_email = recipient_email.to_s.strip.downcase.presence
  end

  def generate_token
    # Generates a unique token for the invite
    # The token is used to identify the invite in URLs.
    # Tokens are unique and will not be reused.
    # NOTE: It is possible for the following to generate
    # a non-unique token, however, the math indicates that
    # the chances of this are so low it would take multiple life times
    # for it to produce a duplicate.
    self.token ||= SecureRandom.hex(20)

  end

  def set_default_expiry
    self.expires_at ||= 7.days.from_now
  end

  def recipient_presence
    # Validates that an invite has either a recipient_id or a recipient_email.
    # We want to allow invites to be created without a recipient_id (e.g. if the
    # recipient is not yet a member of the app) and instead store the recipient's
    # email address. Later, if/when the recipient signs up, we'll update the
    # invite with their user_id.
    if recipient_id.blank? && recipient_email.blank?
      errors.add(:base, "Must have either a recipient_id or a recipient_email")
    end
  end
end
