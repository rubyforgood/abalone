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

ActiveRecord::Schema.define(version: 2020_09_22_202022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animals", force: :cascade do |t|
    t.integer "collection_year"
    t.datetime "date_time_collected"
    t.string "collection_position"
    t.integer "pii_tag"
    t.integer "tag_id"
    t.string "sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_animals_on_organization_id"
  end

  create_table "consolidation_reports", force: :cascade do |t|
    t.bigint "family_id"
    t.bigint "tank_from_id"
    t.bigint "tank_to_id"
    t.string "total_animal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_consolidation_reports_on_family_id"
    t.index ["tank_from_id"], name: "index_consolidation_reports_on_tank_from_id"
    t.index ["tank_to_id"], name: "index_consolidation_reports_on_tank_to_id"
  end

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
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_facilities_on_organization_id"
  end

  create_table "families", force: :cascade do |t|
    t.bigint "female_id"
    t.bigint "male_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tank_id"
    t.string "name"
    t.bigint "organization_id"
    t.index ["female_id"], name: "index_families_on_female_id"
    t.index ["male_id"], name: "index_families_on_male_id"
    t.index ["organization_id"], name: "index_families_on_organization_id"
    t.index ["tank_id"], name: "index_families_on_tank_id"
  end

  create_table "measurement_events", force: :cascade do |t|
    t.string "name"
    t.bigint "tank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tank_id"], name: "index_measurement_events_on_tank_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.string "name"
    t.string "value_type"
    t.jsonb "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.bigint "measurement_event_id"
    t.bigint "processed_file_id"
    t.bigint "animal_id"
    t.bigint "family_id"
    t.bigint "tank_id"
    t.index ["animal_id"], name: "index_measurements_on_animal_id"
    t.index ["family_id"], name: "index_measurements_on_family_id"
    t.index ["measurement_event_id"], name: "index_measurements_on_measurement_event_id"
    t.index ["processed_file_id"], name: "index_measurements_on_processed_file_id"
    t.index ["tank_id"], name: "index_measurements_on_tank_id"
  end

  create_table "mortality_trackings", force: :cascade do |t|
    t.boolean "raw", default: true, null: false
    t.date "mortality_date"
    t.string "cohort"
    t.string "shl_case_number"
    t.date "spawning_date"
    t.integer "shell_box"
    t.string "shell_container"
    t.string "animal_location"
    t.integer "number_morts"
    t.string "approximation"
    t.string "processed_by_shl"
    t.string "initials"
    t.string "tags"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "processed_file_id"
  end

  create_table "operation_batches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operations", force: :cascade do |t|
    t.bigint "tank_id"
    t.integer "animals_added"
    t.integer "animals_added_family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "operation_date"
    t.string "action"
    t.bigint "family_id"
    t.bigint "operation_batch_id"
    t.index ["family_id"], name: "index_operations_on_family_id"
    t.index ["operation_batch_id"], name: "index_operations_on_operation_batch_id"
    t.index ["tank_id"], name: "index_operations_on_tank_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "population_estimates", force: :cascade do |t|
    t.boolean "raw", default: true, null: false
    t.date "sample_date"
    t.string "shl_case_number"
    t.date "spawning_date"
    t.string "lifestage"
    t.integer "abundance"
    t.string "facility"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "processed_file_id"
  end

  create_table "post_settlement_inventories", force: :cascade do |t|
    t.datetime "inventory_date"
    t.integer "mean_standard_length"
    t.integer "total_per_tank"
    t.bigint "tank_id"
    t.index ["tank_id"], name: "index_post_settlement_inventories_on_tank_id"
  end

  create_table "processed_files", force: :cascade do |t|
    t.string "filename"
    t.string "category"
    t.string "status"
    t.jsonb "job_stats", default: "{}", null: false
    t.text "job_errors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "temporary_file_id"
  end

  create_table "tagged_animal_assessments", force: :cascade do |t|
    t.boolean "raw", default: true, null: false
    t.date "measurement_date"
    t.string "shl_case_number"
    t.date "spawning_date"
    t.string "tag"
    t.string "from_growout_rack"
    t.string "from_growout_column"
    t.string "from_growout_trough"
    t.string "to_growout_rack"
    t.string "to_growout_column"
    t.string "to_growout_trough"
    t.decimal "length"
    t.string "gonad_score"
    t.string "predicted_sex"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "processed_file_id"
  end

  create_table "tanks", force: :cascade do |t|
    t.bigint "facility_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["facility_id"], name: "index_tanks_on_facility_id"
    t.index ["organization_id"], name: "index_tanks_on_organization_id"
  end

  create_table "temporary_files", force: :cascade do |t|
    t.text "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wild_collections", force: :cascade do |t|
    t.boolean "raw", default: true, null: false
    t.string "tag"
    t.date "collection_date"
    t.string "general_location"
    t.string "precise_location"
    t.point "collection_coordinates"
    t.string "proximity_to_nearest_neighbor"
    t.string "collection_method_notes"
    t.string "foot_condition_notes"
    t.decimal "collection_depth"
    t.decimal "length"
    t.decimal "weight"
    t.string "gonad_score"
    t.string "predicted_sex"
    t.string "initial_holding_facility"
    t.string "final_holding_facility_and_date_of_arrival"
    t.date "otc_treatment_completion_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "processed_file_id"
  end

  add_foreign_key "animals", "organizations"
  add_foreign_key "consolidation_reports", "families"
  add_foreign_key "families", "organizations"
  add_foreign_key "measurement_events", "tanks"
  add_foreign_key "measurements", "animals"
  add_foreign_key "measurements", "families"
  add_foreign_key "measurements", "measurement_events"
  add_foreign_key "measurements", "processed_files"
  add_foreign_key "measurements", "tanks"
  add_foreign_key "operations", "tanks"
  add_foreign_key "post_settlement_inventories", "tanks"
  add_foreign_key "tanks", "facilities"
  add_foreign_key "tanks", "organizations"
end
