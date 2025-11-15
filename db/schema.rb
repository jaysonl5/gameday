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

ActiveRecord::Schema[7.0].define(version: 2025_09_13_201502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["date"], name: "index_patient_census_entries_on_date"
    t.index ["patient_result"], name: "index_patient_census_entries_on_patient_result"
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

end
