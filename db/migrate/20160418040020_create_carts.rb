class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts, id: false do |t|
      t.string :uuid, primary_key: true, null: false
      t.string :user_uuid, null: false, index: true
      t.string :metadata
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
