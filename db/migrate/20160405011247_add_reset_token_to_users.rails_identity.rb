# This migration comes from rails_identity (originally 20160401223433)
class AddResetTokenToUsers < ActiveRecord::Migration
  def change
    add_column :rails_identity_users, :reset_token, :string
  end
end
