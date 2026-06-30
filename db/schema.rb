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

ActiveRecord::Schema[8.1].define(version: 2026_06_30_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.text "about_me"
    t.string "contact_email", null: false
    t.datetime "created_at", null: false
    t.string "github_link"
    t.string "linkedin_link"
    t.string "location", null: false
    t.string "name", null: false
    t.string "section_title"
    t.datetime "updated_at", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.bigint "user_id"
    t.bigint "visit_id"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "app_version"
    t.string "browser"
    t.string "city"
    t.string "country"
    t.string "device_type"
    t.string "ip"
    t.text "landing_page"
    t.float "latitude"
    t.float "longitude"
    t.string "os"
    t.string "os_version"
    t.string "platform"
    t.text "referrer"
    t.string "referring_domain"
    t.string "region"
    t.datetime "started_at"
    t.text "user_agent"
    t.bigint "user_id"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.string "utm_term"
    t.string "visit_token"
    t.string "visitor_token"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "code_snippet_images", force: :cascade do |t|
    t.bigint "code_snippet_id", null: false
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.datetime "updated_at", null: false
    t.index ["code_snippet_id"], name: "index_code_snippet_images_on_code_snippet_id"
  end

  create_table "code_snippets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "extension", null: false
    t.string "overview", null: false
    t.text "snippet", null: false
    t.text "text"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_code_snippets_on_user_id"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "from", null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_contact_messages_on_user_id"
  end

  create_table "cover_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "link"
    t.bigint "site_setting_id"
    t.datetime "updated_at", null: false
    t.integer "x_loc", default: 50
    t.integer "y_loc", default: 50
    t.index ["site_setting_id"], name: "index_cover_images_on_site_setting_id"
  end

  create_table "gallery_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date_taken", precision: nil
    t.string "description", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_gallery_images_on_user_id"
  end

  create_table "header_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.bigint "site_setting_id"
    t.datetime "updated_at", null: false
    t.integer "x_loc", default: 50
    t.integer "y_loc", default: 50
    t.index ["site_setting_id"], name: "index_header_images_on_site_setting_id"
  end

  create_table "post_section_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", default: "post-image", null: false
    t.bigint "post_section_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["post_section_id"], name: "index_post_section_images_on_post_section_id"
  end

  create_table "post_sections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order", default: 0, null: false
    t.bigint "post_id"
    t.text "text"
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_sections_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date_published", precision: nil, null: false
    t.string "overview", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "visible", default: true, null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "profile_images", force: :cascade do |t|
    t.bigint "about_id"
    t.datetime "created_at", null: false
    t.string "description"
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_profile_images_on_about_id"
  end

  create_table "project_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", default: "project-image", null: false
    t.integer "order"
    t.bigint "project_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_images_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date", precision: nil, null: false
    t.string "github_link"
    t.text "overview"
    t.string "site_link"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "header_text"
    t.string "name"
    t.string "subtitle_text"
    t.boolean "typed_header_enabled"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "current_login_ip"
    t.datetime "current_login_time", precision: nil
    t.text "email"
    t.string "last_login_ip"
    t.datetime "last_login_time", precision: nil
    t.text "mobile_number"
    t.text "password_digest"
    t.datetime "password_reset_expiry", precision: nil
    t.string "password_reset_token"
    t.datetime "updated_at", null: false
    t.text "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "code_snippet_images", "code_snippets"
  add_foreign_key "code_snippets", "users"
  add_foreign_key "contact_messages", "users"
  add_foreign_key "cover_images", "site_settings"
  add_foreign_key "gallery_images", "users"
  add_foreign_key "header_images", "site_settings"
  add_foreign_key "post_section_images", "post_sections"
  add_foreign_key "post_sections", "posts"
  add_foreign_key "posts", "users"
  add_foreign_key "profile_images", "abouts"
  add_foreign_key "project_images", "projects"
end
