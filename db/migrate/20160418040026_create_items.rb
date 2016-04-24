class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: false do |t|
      t.string :uuid, primary_key: true, null: false
      t.string :cart_uuid, index: true
      t.string :order_uuid, index: true
      t.string :product_uuid, null: false
      t.integer :quantity, null: false
      t.string :metadata  # arbitrary json
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
