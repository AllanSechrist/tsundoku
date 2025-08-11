class CreateInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :invites do |t|
      t.references :bookclub, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.string :recipient_email
      t.integer :status
      t.string :token
      t.datetime :expires_at
      t.datetime :accepted_at
      t.datetime :declined_at
      t.datetime :responded_at
      t.text :message

      t.timestamps
    end
    add_index :invites, :token, unique: true

    # Ensure only one pending invite per user per club
    add_index :invites, [:bookclub_id, :recipient_id], unique: true, where: 'status = 0 AND recipient_id IS NOT NULL', name: "index_invites_on_bookclub_id_and_recipient_id"
    add_index :invites, "bookclub_id, LOWER(recipient_email)", unique: true, where: 'status = 0 AND recipient_email IS NOT NULL', name: "index_invites_unique_pending_by_bookclub_and_email"
    add_check_constraint "invites", "(recipient_email IS NOT NULL OR recipient_id IS NOT NULL)", name: "invites_require_recipient"
  end
end
