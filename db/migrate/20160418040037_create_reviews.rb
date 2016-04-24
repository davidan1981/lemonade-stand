class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews, id: false do |t|
      t.string :uuid, primary_key: true, null: false
      t.string :user_uuid, null: false, index: true
      t.string :product_uuid, null: false, index: true
      t.text :feedback, null: false
      t.integer :score, null: false
      t.string :metadata  # arbitrary json
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
