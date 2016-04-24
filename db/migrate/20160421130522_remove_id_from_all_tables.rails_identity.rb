# This migration comes from rails_identity (originally 20160421125651)
class RemoveIdFromAllTables < ActiveRecord::Migration
  def change
    remove_column :rails_identity_users, :id
    remove_column :rails_identity_sessions, :id
  end
end
