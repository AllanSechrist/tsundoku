class MakeRecipientIdNullableOnInvites < ActiveRecord::Migration[7.1]
  def change
    change_column_null :invites, :recipient_id, true
  end
end
