# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_01_10_011539) do
  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "inventories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.integer "current_quantity", default: 0, null: false
    t.integer "optimal_quantity", default: 0, null: false
    t.integer "reorder_threshold", default: 0, null: false
    t.string "shelf_number", null: false
    t.string "unit", null: false
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "last_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_inventories_on_item_id"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "category_id"
    t.string "shelf_number"
    t.integer "current_quantity", null: false
    t.integer "optimal_quantity", null: false
    t.integer "reorder_threshold", null: false
    t.string "unit"
    t.string "manufacturer"
    t.text "supplier_info"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "unit_price", precision: 10, scale: 2
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "message"
    t.bigint "user_id", null: false
    t.bigint "item_id", null: false
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: "unclassified", null: false
    t.index ["item_id"], name: "index_notifications_on_item_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.integer "quantity", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "supplier_info"
    t.index ["item_id"], name: "index_orders_on_item_id"
  end

  create_table "usage_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "user_id", null: false
    t.datetime "usage_date"
    t.integer "quantity"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_usage_records_on_item_id"
    t.index ["user_id"], name: "index_usage_records_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "encrypted_password"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "inventories", "items"
  add_foreign_key "items", "categories"
  add_foreign_key "notifications", "items"
  add_foreign_key "notifications", "users"
  add_foreign_key "orders", "items"
  add_foreign_key "usage_records", "items"
  add_foreign_key "usage_records", "users"
end
