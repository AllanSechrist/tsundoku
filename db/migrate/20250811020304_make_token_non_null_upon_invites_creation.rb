class MakeTokenNonNullUponInvitesCreation < ActiveRecord::Migration[7.1]
  def change
    change_column_null :invites, :token, false
  end
end
