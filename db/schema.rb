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

ActiveRecord::Schema.define(version: 2020_08_07_131216) do

  create_table "candidates", force: :cascade do |t|
    t.integer "recruiter_box_id"
    t.integer "start_date_epoch"
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

end
