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

ActiveRecord::Schema.define(version: 20150928124229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "casserver_lt", force: :cascade do |t|
    t.string   "ticket",          null: false
    t.string   "client_hostname", null: false
    t.datetime "consumed"
    t.datetime "created_on",      null: false
  end

  create_table "casserver_pgt", force: :cascade do |t|
    t.integer  "service_ticket_id", null: false
    t.string   "ticket",            null: false
    t.string   "client_hostname",   null: false
    t.string   "iou",               null: false
    t.datetime "created_on",        null: false
  end

  create_table "casserver_st", force: :cascade do |t|
    t.integer  "granted_by_pgt_id"
    t.integer  "granted_by_tgt_id"
    t.string   "ticket",            null: false
    t.string   "client_hostname",   null: false
    t.text     "service",           null: false
    t.string   "username",          null: false
    t.string   "type",              null: false
    t.datetime "consumed"
    t.datetime "created_on",        null: false
  end

  create_table "casserver_tgt", force: :cascade do |t|
    t.string   "ticket",           null: false
    t.string   "client_hostname",  null: false
    t.string   "username",         null: false
    t.datetime "created_on",       null: false
    t.text     "extra_attributes", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
  end

  create_table "groups_owners", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "owner_id"
  end

  create_table "groups_people", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "group_id",  null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.datetime "birthdate"
    t.string   "email",                                default: "", null: false
    t.string   "legacy_password_sha1",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "legacy_password_sha1_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "admin"
    t.string   "legacy_password_md5"
    t.string   "invitation_token",          limit: 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "invitation_accepted_at"
    t.string   "encrypted_password",                   default: "", null: false
    t.datetime "invitation_created_at"
  end

  add_index "people", ["email"], name: "index_people_on_email", using: :btree
  add_index "people", ["invitation_token"], name: "index_people_on_invitation_token", unique: true, using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "logo_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public"
    t.string   "authentication_token"
    t.string   "urls",                 array: true
  end

  add_index "services", ["authentication_token"], name: "index_services_on_authentication_token", unique: true, using: :btree
  add_index "services", ["public"], name: "index_services_on_public", using: :btree

  create_table "services_oauth_applications", id: false, force: :cascade do |t|
    t.integer "service_id"
    t.integer "oauth_application_id"
  end

  add_index "services_oauth_applications", ["service_id", "oauth_application_id"], name: "services_oauth_applications_idx", unique: true, using: :btree

  create_table "services_users", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "user_id",    null: false
  end

  add_index "services_users", ["user_id"], name: "index_services_users_on_user_id", using: :btree

  add_foreign_key "services_oauth_applications", "oauth_applications"
  add_foreign_key "services_oauth_applications", "services"
end
