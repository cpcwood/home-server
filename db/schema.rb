# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_16_092248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.string "name"
    t.text "about_me"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "linkedin_link"
    t.string "github_link"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cover_images", force: :cascade do |t|
    t.string "link"
    t.string "description"
    t.integer "x_loc", default: 50
    t.integer "y_loc", default: 50
    t.bigint "site_setting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_setting_id"], name: "index_cover_images_on_site_setting_id"
  end

  create_table "header_images", force: :cascade do |t|
    t.string "description"
    t.integer "x_loc", default: 50
    t.integer "y_loc", default: 50
    t.bigint "site_setting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_setting_id"], name: "index_header_images_on_site_setting_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "date_published", null: false
    t.string "overview", null: false
    t.text "text"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "profile_images", force: :cascade do |t|
    t.string "description"
    t.integer "x_loc", default: 50
    t.integer "y_loc", default: 50
    t.bigint "about_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["about_id"], name: "index_profile_images_on_about_id"
  end

  create_table "site_settings", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "typed_header_enabled"
    t.string "header_text"
    t.string "subtitle_text"
  end

  create_table "users", force: :cascade do |t|
    t.text "email"
    t.text "username"
    t.text "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "mobile_number"
    t.string "password_reset_token"
    t.datetime "password_reset_expiry"
    t.string "last_login_ip"
    t.datetime "last_login_time"
    t.string "current_login_ip"
    t.datetime "current_login_time"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cover_images", "site_settings"
  add_foreign_key "header_images", "site_settings"
  add_foreign_key "posts", "users"
  add_foreign_key "profile_images", "abouts"
end
