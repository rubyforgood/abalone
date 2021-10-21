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

ActiveRecord::Schema.define(version: 2021_10_14_153539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :animal_sex, [
    "unknown",
    "male",
    "female",
  ], force: :cascade

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "animals", force: :cascade do |t|
    t.integer "entry_year"
    t.datetime "entry_date"
    t.string "entry_point", default: ""
    t.enum "sex", null: false, enum_name: "animal_sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "cohort_id"
    t.string "tag"
    t.boolean "collected", default: false
    t.index ["cohort_id"], name: "index_animals_on_cohort_id"
    t.index ["organization_id"], name: "index_animals_on_organization_id"
    t.index ["tag", "cohort_id"], name: "index_animals_on_tag_and_cohort_id", unique: true
  end

  create_table "animals_shl_numbers", force: :cascade do |t|
    t.bigint "animal_id"
    t.bigint "shl_number_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["animal_id"], name: "index_animals_shl_numbers_on_animal_id"
    t.index ["shl_number_id"], name: "index_animals_shl_numbers_on_shl_number_id"
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "cohorts", force: :cascade do |t|
    t.bigint "female_id"
    t.bigint "male_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "enclosure_id"
    t.string "name"
    t.bigint "organization_id"
    t.index ["enclosure_id"], name: "index_cohorts_on_enclosure_id"
    t.index ["female_id"], name: "index_cohorts_on_female_id"
    t.index ["male_id"], name: "index_cohorts_on_male_id"
    t.index ["organization_id"], name: "index_cohorts_on_organization_id"
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

  create_table "enclosures", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_enclosures_on_location_id"
    t.index ["organization_id"], name: "index_enclosures_on_organization_id"
  end

  create_table "exit_types", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_exit_types_on_organization_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_facilities_on_organization_id"
  end

  create_table "file_uploads", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.text "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_file_uploads_on_organization_id"
    t.index ["user_id"], name: "index_file_uploads_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.bigint "facility_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["facility_id"], name: "index_locations_on_facility_id"
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "measurement_events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_measurement_events_on_organization_id"
  end

  create_table "measurement_types", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.bigint "organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_measurement_types_on_organization_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.bigint "measurement_event_id"
    t.bigint "processed_file_id"
    t.bigint "organization_id"
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.bigint "measurement_type_id"
    t.index ["measurement_event_id"], name: "index_measurements_on_measurement_event_id"
    t.index ["measurement_type_id"], name: "index_measurements_on_measurement_type_id"
    t.index ["organization_id"], name: "index_measurements_on_organization_id"
    t.index ["processed_file_id"], name: "index_measurements_on_processed_file_id"
    t.index ["subject_type", "subject_id"], name: "index_measurements_on_subject_type_and_subject_id"
  end

  create_table "mortality_events", force: :cascade do |t|
    t.datetime "mortality_date"
    t.bigint "animal_id"
    t.bigint "cohort_id"
    t.integer "mortality_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "exit_type_id"
    t.bigint "organization_id"
    t.bigint "processed_file_id"
    t.index ["animal_id"], name: "index_mortality_events_on_animal_id"
    t.index ["cohort_id"], name: "index_mortality_events_on_cohort_id"
    t.index ["exit_type_id"], name: "index_mortality_events_on_exit_type_id"
    t.index ["organization_id"], name: "index_mortality_events_on_organization_id"
    t.index ["processed_file_id"], name: "index_mortality_events_on_processed_file_id"
  end

  create_table "operation_batches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operations", force: :cascade do |t|
    t.bigint "enclosure_id"
    t.integer "animals_added"
    t.integer "animals_added_cohort_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "operation_date"
    t.string "action"
    t.bigint "cohort_id"
    t.bigint "operation_batch_id"
    t.bigint "organization_id"
    t.index ["cohort_id"], name: "index_operations_on_cohort_id"
    t.index ["enclosure_id"], name: "index_operations_on_enclosure_id"
    t.index ["operation_batch_id"], name: "index_operations_on_operation_batch_id"
    t.index ["organization_id"], name: "index_operations_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_processed_files_on_organization_id"
  end

  create_table "shl_numbers", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "animals", "organizations"
  add_foreign_key "cohorts", "organizations"
  add_foreign_key "enclosures", "organizations"
  add_foreign_key "exit_types", "organizations"
  add_foreign_key "file_uploads", "organizations"
  add_foreign_key "file_uploads", "users"
  add_foreign_key "locations", "facilities"
  add_foreign_key "locations", "organizations"
  add_foreign_key "measurement_events", "organizations"
  add_foreign_key "measurements", "measurement_events"
  add_foreign_key "measurements", "organizations"
  add_foreign_key "measurements", "processed_files"
  add_foreign_key "mortality_events", "exit_types"
  add_foreign_key "mortality_events", "organizations"
  add_foreign_key "mortality_events", "processed_files"
  add_foreign_key "operations", "enclosures"
  add_foreign_key "operations", "organizations"
  add_foreign_key "processed_files", "organizations"
end
