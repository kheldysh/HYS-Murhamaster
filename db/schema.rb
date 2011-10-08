# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111008172021) do

  create_table "assignments", :force => true do |t|
    t.integer  "player_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
    t.integer  "ring_id"
    t.integer  "warrant_id"
  end

  create_table "calendars", :force => true do |t|
    t.integer  "user_id"
    t.text     "monday"
    t.text     "tuesday"
    t.text     "wednesday"
    t.text     "thursday"
    t.text     "friday"
    t.text     "saturday"
    t.text     "sunday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "misc"
  end

  create_table "events", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "murders",       :default => 0, :null => false
    t.integer  "kills",         :default => 0, :null => false
    t.integer  "arrests",       :default => 0, :null => false
    t.integer  "collaterals",   :default => 0, :null => false
    t.integer  "witnesses",     :default => 0, :null => false
    t.integer  "eyewitnesses",  :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "time"
    t.integer  "tournament_id"
  end

  create_table "fileLocal", :force => true do |t|
    t.string  "fileName"
    t.integer "fileSize", :limit => 8
    t.string  "location"
    t.integer "ownerId",  :limit => 8
  end

  create_table "fileRemote", :force => true do |t|
    t.string  "fileHash"
    t.string  "fileName"
    t.integer "fileSize",           :limit => 8
    t.string  "ownerHash"
    t.integer "uploadDate",         :limit => 8
    t.integer "chunkCount"
    t.integer "minimalChunksCount"
  end

  create_table "pictures", :force => true do |t|
    t.string   "name"
    t.string   "content_type"
    t.binary   "data",         :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "players", :force => true do |t|
    t.string   "alias"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.integer  "referee_id"
  end

  create_table "referees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rings", :force => true do |t|
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_assignments", :force => true do |t|
    t.integer  "team_id"
    t.integer  "target_id"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "tournament_id"
    t.string   "organization"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "title"
    t.date     "start_date"
    t.date     "finish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "app_deadline"
    t.boolean  "team_game",    :default => false
    t.integer  "murdered",     :default => 0,     :null => false
    t.integer  "killed",       :default => 0,     :null => false
    t.integer  "arrested",     :default => 0,     :null => false
    t.integer  "collaterals",  :default => 0,     :null => false
    t.integer  "witnesses",    :default => 0,     :null => false
    t.integer  "eyewitnesses", :default => 0,     :null => false
  end

  create_table "user", :force => true do |t|
    t.string "hash"
    t.string "login"
    t.string "pass"
  end

  add_index "user", ["login"], :name => "I_login", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "phone"
    t.string   "address"
    t.string   "eyes"
    t.string   "glasses"
    t.integer  "height"
    t.string   "hair"
    t.string   "other_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",       :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "university"
    t.string   "faculty"
    t.string   "department"
    t.datetime "last_login"
  end

  create_table "warrants", :force => true do |t|
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_id"
  end

end
