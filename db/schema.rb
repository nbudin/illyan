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

ActiveRecord::Schema.define(version: 2022_07_06_154107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "casserver_lt", id: :serial, force: :cascade do |t|
    t.string "ticket", limit: 255, null: false
    t.string "client_hostname", limit: 255, null: false
    t.datetime "consumed"
    t.datetime "created_on", null: false
  end

  create_table "casserver_pgt", id: :serial, force: :cascade do |t|
    t.integer "service_ticket_id", null: false
    t.string "ticket", limit: 255, null: false
    t.string "client_hostname", limit: 255, null: false
    t.string "iou", limit: 255, null: false
    t.datetime "created_on", null: false
  end

  create_table "casserver_st", id: :serial, force: :cascade do |t|
    t.integer "granted_by_pgt_id"
    t.integer "granted_by_tgt_id"
    t.string "ticket", limit: 255, null: false
    t.string "client_hostname", limit: 255, null: false
    t.text "service", null: false
    t.string "username", limit: 255, null: false
    t.string "type", limit: 255, null: false
    t.datetime "consumed"
    t.datetime "created_on", null: false
  end

  create_table "casserver_tgt", id: :serial, force: :cascade do |t|
    t.string "ticket", limit: 255, null: false
    t.string "client_hostname", limit: 255, null: false
    t.string "username", limit: 255, null: false
    t.datetime "created_on", null: false
    t.text "extra_attributes", null: false
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "groups_owners", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "owner_id"
  end

  create_table "groups_people", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "group_id", null: false
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "firstname", limit: 255
    t.string "lastname", limit: 255
    t.string "gender", limit: 255
    t.datetime "birthdate"
    t.string "email", limit: 255, default: "", null: false
    t.string "legacy_password_sha1", limit: 128, default: "", null: false
    t.string "legacy_password_sha1_salt", limit: 255, default: "", null: false
    t.string "remember_token", limit: 255
    t.datetime "remember_created_at"
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "reset_password_token", limit: 255
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin"
    t.string "legacy_password_md5", limit: 255
    t.string "invitation_token", limit: 255
    t.datetime "invitation_sent_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type", limit: 255
    t.datetime "invitation_accepted_at"
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.datetime "reset_password_sent_at"
    t.datetime "invitation_created_at"
    t.index ["email"], name: "index_people_on_email"
    t.index ["invitation_token"], name: "index_people_on_invitation_token", unique: true
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "logo_url", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "public"
    t.string "authentication_token", limit: 255
    t.string "urls", limit: 255, array: true
    t.integer "oauth_application_id"
    t.boolean "auto_authorize", default: false, null: false
    t.index ["public"], name: "index_services_on_public"
  end

  create_table "services_users", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_services_users_on_user_id"
  end

  create_table "ticket_granting_cookies", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.string "username", limit: 255, null: false
    t.datetime "consumed_at"
    t.text "extra_attributes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "services", "oauth_applications"
end
