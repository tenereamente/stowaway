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

ActiveRecord::Schema.define(version: 20131128172858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogit_comments", force: true do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.string   "website"
    t.text     "body",       null: false
    t.integer  "post_id",    null: false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogit_comments", ["post_id"], name: "index_blogit_comments_on_post_id", using: :btree

  create_table "blogit_posts", force: true do |t|
    t.string   "title",                      null: false
    t.text     "body",                       null: false
    t.integer  "blogger_id"
    t.string   "blogger_type"
    t.integer  "comments_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogit_posts", ["blogger_type", "blogger_id"], name: "index_blogit_posts_on_blogger_type_and_blogger_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], name: "index_notifications_on_conversation_id", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "receipts", ["notification_id"], name: "index_receipts_on_notification_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "space_rentals", force: true do |t|
    t.integer  "user_id"
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spaces", force: true do |t|
    t.integer  "user_id"
    t.integer  "height"
    t.integer  "length"
    t.integer  "width"
    t.string   "units"
    t.text     "notes"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "normalized_address"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "environment"
    t.string   "access"
    t.string   "type"
    t.string   "title"
    t.boolean  "complete",            default: false
    t.boolean  "available",           default: false
    t.string   "photo2_file_name"
    t.string   "photo2_content_type"
    t.integer  "photo2_file_size"
    t.datetime "photo2_updated_at"
    t.string   "photo3_file_name"
    t.string   "photo3_content_type"
    t.integer  "photo3_file_size"
    t.datetime "photo3_updated_at"
    t.string   "photo4_file_name"
    t.string   "photo4_content_type"
    t.integer  "photo4_file_size"
    t.datetime "photo4_updated_at"
    t.string   "photo5_file_name"
    t.string   "photo5_content_type"
    t.integer  "photo5_file_size"
    t.datetime "photo5_updated_at"
    t.boolean  "climate_controlled",  default: false
    t.boolean  "lockable",            default: false
    t.boolean  "attended",            default: false
    t.boolean  "featured",            default: false
    t.integer  "monthly_price",       default: 50
  end

  create_table "stripe_events", force: true do |t|
    t.string   "event_id"
    t.json     "data",                       null: false
    t.boolean  "handled",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.boolean  "livemode"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "zip"
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "bio"
    t.string   "stripe_customer_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
