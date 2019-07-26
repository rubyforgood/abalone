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

ActiveRecord::Schema.define(version: 2019_07_26_182100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wild_collections", force: :cascade do |t|
    t.boolean "raw", default: true, null: false
    t.string "tag"
    t.date "collection_date"
    t.string "general_location"
    t.string "precise_location"
    t.point "collection_coodinates"
    t.string "proximity_to_nearest_neighbor"
    t.string "collection_method_notes"
    t.string "foot_condition_notes"
    t.string "collection_depth"
    t.string "length"
    t.string "weight"
    t.string "gonad_score"
    t.string "predicted_sex"
    t.string "initial_holding_facility"
    t.string "final_holding_facility_date_of_arrival"
    t.string "otc_treatment_completion_date"
  end

  create_table "spawning_successes", force: :cascade do |t|
    t.boolean "raw", default: true, null: false
    t.string "tag"
    t.decimal "shl_number"
    t.date "spawning_date"
    t.date "date_attempted"
    t.string "spawning_success"
    t.decimal "nbr_of_eggs_spawned"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
