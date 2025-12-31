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

ActiveRecord::Schema[7.0].define(version: 2025_12_31_034511) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discounts", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "percentage", precision: 5, scale: 2
    t.integer "fixed_amount"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_discounts_on_active"
    t.index ["name"], name: "index_discounts_on_name"
  end

  create_table "ghl_appointments", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "ghl_appointment_id", null: false
    t.string "ghl_calendar_id"
    t.string "appointment_status"
    t.datetime "scheduled_at"
    t.datetime "end_time"
    t.string "appointment_type"
    t.text "notes"
    t.boolean "patient_created", default: false
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_status"], name: "index_ghl_appointments_on_appointment_status"
    t.index ["ghl_appointment_id"], name: "index_ghl_appointments_on_ghl_appointment_id", unique: true
    t.index ["patient_created"], name: "index_ghl_appointments_on_patient_created"
    t.index ["patient_id"], name: "index_ghl_appointments_on_patient_id"
    t.index ["scheduled_at"], name: "index_ghl_appointments_on_scheduled_at"
  end

  create_table "ghl_sync_logs", force: :cascade do |t|
    t.string "sync_type", null: false
    t.string "status", null: false
    t.integer "records_processed", default: 0
    t.integer "records_created", default: 0
    t.integer "records_updated", default: 0
    t.integer "records_failed", default: 0
    t.text "error_message"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["started_at"], name: "index_ghl_sync_logs_on_started_at"
    t.index ["status"], name: "index_ghl_sync_logs_on_status"
    t.index ["sync_type"], name: "index_ghl_sync_logs_on_sync_type"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "default_dose", precision: 5, scale: 2
    t.json "typical_vial_sizes"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_medications_on_active"
    t.index ["name"], name: "index_medications_on_name", unique: true
  end

  create_table "patient_calls", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "callable_type", null: false
    t.bigint "callable_id", null: false
    t.string "call_type", null: false
    t.date "scheduled_date", null: false
    t.datetime "completed_at"
    t.string "outcome"
    t.text "encrypted_notes"
    t.string "encrypted_notes_iv"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_type"], name: "index_patient_calls_on_call_type"
    t.index ["callable_type", "callable_id"], name: "index_patient_calls_on_callable"
    t.index ["callable_type", "callable_id"], name: "index_patient_calls_on_callable_type_and_callable_id"
    t.index ["completed_at"], name: "index_patient_calls_on_completed_at"
    t.index ["deleted_at"], name: "index_patient_calls_on_deleted_at"
    t.index ["patient_id"], name: "index_patient_calls_on_patient_id"
    t.index ["scheduled_date"], name: "index_patient_calls_on_scheduled_date"
  end

  create_table "patient_census_entries", force: :cascade do |t|
    t.date "date", null: false
    t.string "patient_name", null: false
    t.string "patient_result", null: false
    t.string "mail_out_in_clinic"
    t.decimal "in_clinic_dose_ml", precision: 5, scale: 2
    t.string "med_order_made"
    t.string "lab_call_scheduled"
    t.string "monthly_contract_made"
    t.string "annual_lab_contract"
    t.string "consents_signed"
    t.string "in_clinic_appt_made"
    t.string "mail_out_appt_made"
    t.text "notes"
    t.string "lead_source"
    t.text "plan_notes"
    t.integer "rate"
    t.text "extra_info"
    t.string "p_or_other"
    t.string "phone_number"
    t.text "why_a_loss"
    t.json "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_patient_name"
    t.string "encrypted_patient_name_iv"
    t.string "encrypted_phone_number"
    t.string "encrypted_phone_number_iv"
    t.text "encrypted_notes"
    t.string "encrypted_notes_iv"
    t.text "encrypted_plan_notes"
    t.string "encrypted_plan_notes_iv"
    t.text "encrypted_extra_info"
    t.string "encrypted_extra_info_iv"
    t.text "encrypted_why_a_loss"
    t.string "encrypted_why_a_loss_iv"
    t.datetime "call_logged_at"
    t.bigint "patient_id", null: false
    t.index ["date"], name: "index_patient_census_entries_on_date"
    t.index ["patient_id"], name: "index_patient_census_entries_on_patient_id"
    t.index ["patient_result"], name: "index_patient_census_entries_on_patient_result"
  end

  create_table "patient_labs", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "patient_medication_id"
    t.string "lab_type", null: false
    t.date "last_lab_date"
    t.integer "frequency_value", null: false
    t.string "frequency_unit", null: false
    t.date "next_lab_due"
    t.string "status"
    t.text "encrypted_notes"
    t.string "encrypted_notes_iv"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_patient_labs_on_deleted_at"
    t.index ["next_lab_due"], name: "index_patient_labs_on_next_lab_due"
    t.index ["patient_id"], name: "index_patient_labs_on_patient_id"
    t.index ["patient_medication_id"], name: "index_patient_labs_on_patient_medication_id"
    t.index ["status"], name: "index_patient_labs_on_status"
  end

  create_table "patient_medications", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "medication_id", null: false
    t.bigint "discount_id"
    t.boolean "prepped", default: false
    t.decimal "dose_per_week", precision: 5, scale: 2, null: false
    t.decimal "vial_size", precision: 5, scale: 2, null: false
    t.integer "rate"
    t.string "dispensing_method"
    t.decimal "in_clinic_dose", precision: 5, scale: 2
    t.date "last_order_date"
    t.integer "order_buffer_days", default: 7
    t.boolean "declined", default: false
    t.integer "days_supply"
    t.date "next_order_due"
    t.date "order_by_date"
    t.string "status"
    t.text "encrypted_notes"
    t.string "encrypted_notes_iv"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_patient_medications_on_deleted_at"
    t.index ["discount_id"], name: "index_patient_medications_on_discount_id"
    t.index ["dispensing_method"], name: "index_patient_medications_on_dispensing_method"
    t.index ["medication_id"], name: "index_patient_medications_on_medication_id"
    t.index ["next_order_due"], name: "index_patient_medications_on_next_order_due"
    t.index ["order_by_date"], name: "index_patient_medications_on_order_by_date"
    t.index ["patient_id", "medication_id"], name: "index_patient_medications_on_patient_id_and_medication_id"
    t.index ["patient_id"], name: "index_patient_medications_on_patient_id"
    t.index ["status"], name: "index_patient_medications_on_status"
  end

  create_table "patient_profiles", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "discount_id"
    t.string "lead_source"
    t.integer "rate"
    t.boolean "monthly_contract_made", default: false
    t.boolean "annual_contract_made", default: false
    t.string "patient_result"
    t.date "consult_date"
    t.text "encrypted_extra_info"
    t.string "encrypted_extra_info_iv"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consult_date"], name: "index_patient_profiles_on_consult_date"
    t.index ["deleted_at"], name: "index_patient_profiles_on_deleted_at"
    t.index ["discount_id"], name: "index_patient_profiles_on_discount_id"
    t.index ["patient_id"], name: "index_patient_profiles_on_patient_id"
    t.index ["patient_result"], name: "index_patient_profiles_on_patient_result"
  end

  create_table "patients", force: :cascade do |t|
    t.string "encrypted_name"
    t.string "encrypted_name_iv"
    t.string "encrypted_name_bidx"
    t.string "encrypted_email"
    t.string "encrypted_email_iv"
    t.string "encrypted_email_bidx"
    t.string "encrypted_phone"
    t.string "encrypted_phone_iv"
    t.text "encrypted_notes"
    t.string "encrypted_notes_iv"
    t.string "status", default: "new_lead", null: false
    t.datetime "status_changed_at"
    t.string "ghl_contact_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_patients_on_deleted_at"
    t.index ["encrypted_email_bidx"], name: "index_patients_on_encrypted_email_bidx"
    t.index ["encrypted_name_bidx"], name: "index_patients_on_encrypted_name_bidx"
    t.index ["ghl_contact_id"], name: "index_patients_on_ghl_contact_id", unique: true
    t.index ["status"], name: "index_patients_on_status"
    t.index ["status_changed_at"], name: "index_patients_on_status_changed_at"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at_api"
    t.bigint "api_id", null: false
    t.string "creator_name"
    t.boolean "is_duplicate"
    t.bigint "merchant_id"
    t.string "tender_type"
    t.string "currency"
    t.decimal "amount", precision: 15, scale: 2
    t.string "card_type"
    t.string "card_last4"
    t.integer "customer_id"
    t.boolean "auth_only"
    t.string "auth_code"
    t.string "status"
    t.boolean "avs_account_name_match_performed"
    t.decimal "settled_amount", precision: 15, scale: 2
    t.string "settled_currency"
    t.string "auth_message"
    t.decimal "available_auth_amount", precision: 15, scale: 2
    t.string "reference"
    t.decimal "tax", precision: 15, scale: 2
    t.decimal "surcharge_amount", precision: 15, scale: 2
    t.decimal "surcharge_rate", precision: 5, scale: 2
    t.string "surcharge_label"
    t.string "invoice"
    t.string "client_reference"
    t.string "payment_type"
    t.integer "review_indicator"
    t.string "source"
    t.boolean "should_get_credit_card_level"
    t.integer "response_code"
    t.string "issuer_response_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recurring", default: false, null: false
    t.index ["api_id"], name: "index_payments_on_api_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "avatar_url"
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "whodunnit"
    t.datetime "created_at"
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.string "event", null: false
    t.text "object"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "ghl_appointments", "patients"
  add_foreign_key "patient_calls", "patients"
  add_foreign_key "patient_census_entries", "patients"
  add_foreign_key "patient_labs", "patient_medications"
  add_foreign_key "patient_labs", "patients"
  add_foreign_key "patient_medications", "discounts"
  add_foreign_key "patient_medications", "medications"
  add_foreign_key "patient_medications", "patients"
  add_foreign_key "patient_profiles", "discounts"
  add_foreign_key "patient_profiles", "patients"
end
