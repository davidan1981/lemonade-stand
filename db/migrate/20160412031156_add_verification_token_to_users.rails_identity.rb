# This migration comes from rails_identity (originally 20160411215917)
class AddVerificationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :rails_identity_users, :verification_token, :string
    add_column :rails_identity_users, :verified, :boolean, default: false

    # Assign true for existing accounts since they existed without
    # a verification token.
    users = RailsIdentity::User.update_all(verified: true)
  end
end
