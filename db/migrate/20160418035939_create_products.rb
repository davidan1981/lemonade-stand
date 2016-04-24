class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products, id: false do |t|
      t.string :uuid, primary_key: true, null: false
      t.boolean :enabled
      t.string :title, null: false
      t.string :summary
      t.text :description, null: false
      t.integer :orig_price
      t.integer :sale_price, null: false, index: true
      t.integer :base_shipping, null: false
      t.integer :add_on_shipping, null: false
      t.integer :quantity
      t.string :metadata
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
