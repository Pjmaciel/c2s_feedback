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

ActiveRecord::Schema[7.1].define(version: 2025_02_10_125218) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendant_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "registration_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_number"], name: "index_attendant_profiles_on_registration_number", unique: true
  end

  create_table "client_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_client_profiles_on_cpf", unique: true
  end

  create_table "evaluation_requests", force: :cascade do |t|
    t.bigint "attendant_id", null: false
    t.bigint "client_id", null: false
    t.string "evaluation_token", null: false
    t.string "status", default: "pending", null: false
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendant_id"], name: "index_evaluation_requests_on_attendant_id"
    t.index ["client_id"], name: "index_evaluation_requests_on_client_id"
    t.index ["evaluation_token"], name: "index_evaluation_requests_on_evaluation_token", unique: true
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "attendant_id", null: false
    t.bigint "client_id", null: false
    t.integer "score", null: false
    t.text "comment", null: false
    t.datetime "evaluation_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sentiment"
    t.index ["attendant_id"], name: "index_evaluations_on_attendant_id"
    t.index ["client_id", "attendant_id", "evaluation_date"], name: "idx_on_client_id_attendant_id_evaluation_date_14449bfc1a"
    t.index ["client_id"], name: "index_evaluations_on_client_id"
    t.index ["sentiment"], name: "index_evaluations_on_sentiment"
  end

  create_table "manager_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "registration_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_number"], name: "index_manager_profiles_on_registration_number", unique: true
    t.index ["user_id"], name: "index_manager_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "evaluation_requests", "users", column: "attendant_id"
  add_foreign_key "evaluation_requests", "users", column: "client_id"
  add_foreign_key "evaluations", "users", column: "attendant_id"
  add_foreign_key "evaluations", "users", column: "client_id"
  add_foreign_key "manager_profiles", "users"
end
