class CreateInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :invites do |t|
      t.references :bookclub, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
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
  end
end
