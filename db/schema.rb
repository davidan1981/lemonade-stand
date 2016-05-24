# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160524024903) do

  create_table "carts", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.string   "user_uuid",  null: false
    t.string   "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "carts", ["deleted_at"], name: "index_carts_on_deleted_at"
  add_index "carts", ["user_uuid"], name: "index_carts_on_user_uuid"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "items", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.string   "cart_uuid"
    t.string   "order_uuid"
    t.string   "product_uuid", null: false
    t.integer  "quantity",     null: false
    t.string   "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "items", ["cart_uuid"], name: "index_items_on_cart_uuid"
  add_index "items", ["deleted_at"], name: "index_items_on_deleted_at"
  add_index "items", ["order_uuid"], name: "index_items_on_order_uuid"

  create_table "orders", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.string   "user_uuid",  null: false
    t.string   "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at"
  add_index "orders", ["user_uuid"], name: "index_orders_on_user_uuid"

  create_table "product_images", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.string   "product_uuid"
    t.string   "url"
    t.string   "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "product_images", ["deleted_at"], name: "index_product_images_on_deleted_at"

  create_table "products", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.boolean  "enabled"
    t.string   "title",           null: false
    t.string   "summary"
    t.text     "description",     null: false
    t.integer  "orig_price"
    t.integer  "sale_price",      null: false
    t.integer  "base_shipping",   null: false
    t.integer  "add_on_shipping", null: false
    t.integer  "quantity"
    t.string   "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at"
  add_index "products", ["sale_price"], name: "index_products_on_sale_price"

  create_table "rails_identity_sessions", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.string   "user_uuid",  null: false
    t.string   "token",      null: false
    t.string   "secret",     null: false
    t.string   "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_identity_users", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "role"
    t.string   "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "reset_token"
    t.string   "verification_token"
    t.boolean  "verified",           default: false
    t.string   "type"
    t.string   "api_key"
    t.string   "oauth_provider"
    t.string   "oauth_uid"
    t.string   "oauth_name"
    t.string   "oauth_token"
    t.string   "oauth_expires_at"
  end

  add_index "rails_identity_users", ["api_key"], name: "index_rails_identity_users_on_api_key"
  add_index "rails_identity_users", ["deleted_at"], name: "index_rails_identity_users_on_deleted_at"
  add_index "rails_identity_users", ["oauth_provider", "oauth_uid"], name: "index_rails_identity_users_on_oauth_provider_and_oauth_uid"

  create_table "reviews", id: false, force: :cascade do |t|
    t.string   "uuid"
    t.string   "user_uuid",    null: false
    t.string   "product_uuid", null: false
    t.text     "feedback",     null: false
    t.integer  "score",        null: false
    t.string   "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "reviews", ["deleted_at"], name: "index_reviews_on_deleted_at"
  add_index "reviews", ["product_uuid"], name: "index_reviews_on_product_uuid"
  add_index "reviews", ["user_uuid"], name: "index_reviews_on_user_uuid"

end
