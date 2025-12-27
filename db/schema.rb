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

ActiveRecord::Schema[7.1].define(version: 2025_12_27_101526) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name", null: false
    t.string "serial_number", null: false
    t.string "location"
    t.date "purchase_date"
    t.date "warranty_expiry"
    t.boolean "is_scrapped", default: false
    t.bigint "department_id", null: false
    t.bigint "maintenance_team_id", null: false
    t.integer "default_technician_id"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_equipment_on_department_id"
    t.index ["maintenance_team_id"], name: "index_equipment_on_maintenance_team_id"
    t.index ["serial_number"], name: "index_equipment_on_serial_number", unique: true
  end

  create_table "maintenance_requests", force: :cascade do |t|
    t.string "subject", null: false
    t.string "request_type", null: false
    t.string "state", default: "new", null: false
    t.datetime "scheduled_at"
    t.integer "duration"
    t.bigint "equipment_id", null: false
    t.integer "technician_id"
    t.integer "maintenance_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_maintenance_requests_on_equipment_id"
    t.index ["request_type"], name: "index_maintenance_requests_on_request_type"
    t.index ["scheduled_at"], name: "index_maintenance_requests_on_scheduled_at"
    t.index ["state"], name: "index_maintenance_requests_on_state"
  end

  create_table "maintenance_teams", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_maintenance_teams_on_department_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "maintenance_team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maintenance_team_id"], name: "index_team_members_on_maintenance_team_id"
    t.index ["user_id", "maintenance_team_id"], name: "index_team_members_on_user_id_and_maintenance_team_id", unique: true
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "role", default: "employee", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "equipment", "departments"
  add_foreign_key "equipment", "maintenance_teams"
  add_foreign_key "maintenance_requests", "equipment"
  add_foreign_key "maintenance_teams", "departments"
  add_foreign_key "team_members", "maintenance_teams"
  add_foreign_key "team_members", "users"
end
