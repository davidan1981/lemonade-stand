class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images, id: false do |t|
      t.string :uuid, primary_key: true, null: false
      t.string :product_uuid
      t.string :url
      t.string :metadata  # json
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
