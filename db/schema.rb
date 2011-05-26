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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110526142030) do

  create_table "groups", :force => true do |t|
    t.string "name"
  end

  create_table "groups_owners", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "owner_id"
  end

  create_table "groups_people", :id => false, :force => true do |t|
    t.integer "person_id", :null => false
    t.integer "group_id",  :null => false
  end

  create_table "login_tickets", :force => true do |t|
    t.string    "ticket",          :null => false
    t.string    "client_hostname", :null => false
    t.timestamp "consumed_at"
    t.timestamp "created_at",      :null => false
  end

  create_table "people", :force => true do |t|
    t.string    "firstname"
    t.string    "lastname"
    t.string    "gender"
    t.timestamp "birthdate"
    t.string    "email",                               :default => "", :null => false
    t.string    "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string    "password_salt",                       :default => "", :null => false
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.string    "confirmation_token"
    t.timestamp "confirmed_at"
    t.timestamp "confirmation_sent_at"
    t.string    "reset_password_token"
    t.integer   "sign_in_count",                       :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "admin"
    t.string    "legacy_password_md5"
    t.string    "invitation_token",     :limit => 60
    t.timestamp "invitation_sent_at"
    t.integer   "invitation_limit"
    t.integer   "invited_by_id"
    t.string    "invited_by_type"
  end

  add_index "people", ["email"], :name => "index_people_on_email"
  add_index "people", ["invitation_token"], :name => "index_people_on_invitation_token", :unique => true

  create_table "proxy_granting_tickets", :force => true do |t|
    t.integer   "service_ticket_id", :null => false
    t.string    "ticket",            :null => false
    t.string    "client_hostname",   :null => false
    t.string    "iou",               :null => false
    t.timestamp "created_at",        :null => false
  end

  create_table "service_tickets", :force => true do |t|
    t.integer   "proxy_granting_ticket_id"
    t.integer   "ticket_granting_ticket_id"
    t.string    "ticket",                    :null => false
    t.string    "client_hostname",           :null => false
    t.text      "service",                   :null => false
    t.string    "username",                  :null => false
    t.string    "type"
    t.timestamp "consumed_at"
    t.timestamp "created_at",                :null => false
  end

  create_table "services", :force => true do |t|
    t.string    "name"
    t.string    "url"
    t.string    "logo_url"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "public"
    t.string    "authentication_token"
  end

  add_index "services", ["public"], :name => "index_services_on_public"

  create_table "services_users", :id => false, :force => true do |t|
    t.integer "service_id", :null => false
    t.integer "user_id",    :null => false
  end

  add_index "services_users", ["user_id"], :name => "index_services_users_on_user_id"

  create_table "ticket_granting_cookies", :force => true do |t|
    t.string    "value",            :null => false
    t.string    "username",         :null => false
    t.timestamp "consumed_at"
    t.text      "extra_attributes"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "ticket_granting_tickets", :force => true do |t|
    t.string    "ticket",          :null => false
    t.string    "client_hostname", :null => false
    t.string    "username",        :null => false
    t.timestamp "created_at",      :null => false
  end

end
