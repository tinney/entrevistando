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

ActiveRecord::Schema.define(version: 2020_12_12_232818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.integer "recruiterbox_id"
    t.integer "start_date_epoch"
    t.integer "updated_date_epoch"
    t.integer "end_date_epoch"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "source"
    t.integer "stage_id"
    t.integer "opening_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "assigned"
  end

  create_table "interviews", force: :cascade do |t|
    t.integer "recruiterbox_id"
    t.string "title"
    t.integer "time_epoch"
    t.integer "date_created"
    t.bigint "candidate_id"
    t.bigint "user_id"
    t.index ["candidate_id"], name: "index_interviews_on_candidate_id"
    t.index ["user_id"], name: "index_interviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
