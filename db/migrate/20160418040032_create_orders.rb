class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, id: false do |t|
      t.string :uuid, primary_key: true, null: false
      t.string :user_uuid, null: false, index: true
      t.string :metadata  # arbitrary json
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
