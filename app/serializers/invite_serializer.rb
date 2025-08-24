class InviteSerializer
  include JSONAPI::Serializer

  set_type :invite

  belongs_to :bookclub, serializer: BookclubSerializer
  belongs_to :sender, serializer: UserSerializer
  # When serializing an Invite, include the recipient only if recipient_id is set
  belongs_to :recipient, serializer: UserSerializer, if: proc { |obj| obj.recipient_id.present? }

  attributes :bookclub_id, :sender_id, :recipient_id,
             :message, :expires_at, :accepted_at, :declined_at, :responded_at,
             :created_at, :updated_at

  # Present enum as string
  attribute :status do |invite|
    invite.status.to_s
  end

  attribute :recipient_email do |invite, params|
    # Hide user email for privacy reasons, unless
    # viewing the email is allowed i.e. admin reasons.
    email = invite.recipient_email
    next nil if email.blank?
    # Show email is passed in the controller as a param
    if params && params[:show_email]
      email
    else
      local, domain = email.split('@', 2)
      head = local.to_s[0].to_s
      domain ? "#{head}***@#{domain}" : email
    end
  end

  # Only expose token when explicitly allowed (e.g., right after create)
  attribute :token, if: proc { |_invite, params| params && params[:show_token] } do |invite|
    invite.token
  end

  attribute :expired do |invite|
    invite.expires_at.present? && invite.expires_at <= Time.current
  end

  attribute :responded do |invite|
    invite.responded_at.present?
  end
end
