class AddIndexToToken < ActiveRecord::Migration[7.1]
  def change
    add_index :invites, :token, unique: true
  end
end
