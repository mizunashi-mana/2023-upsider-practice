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

ActiveRecord::Schema[7.0].define(version: 2023_10_02_124148) do
  create_table "customer_bank_accounts", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "owner_customer_id", null: false
    t.string "name", limit: 510, null: false
    t.binary "others", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_customer_id"], name: "index_customer_bank_accounts_on_owner_customer_id"
  end

  create_table "customers", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "target_organization_id", null: false
    t.string "name", limit: 510, null: false
    t.binary "others", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_organization_id"], name: "index_customers_on_target_organization_id"
  end

  create_table "invoices", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "issued_customer_id", null: false
    t.integer "status", null: false
    t.date "issued_date", null: false
    t.date "payment_due_date", null: false
    t.integer "payment_amount_jpy", null: false
    t.integer "claimed_amount_jpy", null: false
    t.binary "others", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "\"payer_organization_id\", \"payment_due_date\"", name: "index_invoices_on_org_and_duedt"
    t.index ["issued_customer_id"], name: "index_invoices_on_issued_customer_id"
  end

  create_table "organizations", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "name", limit: 510, null: false
    t.binary "others", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_authority_on_customers", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "customer_id", null: false
    t.string "user_id", null: false
    t.binary "others", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "user_id"], name: "index_user_auth_on_cust_ids", unique: true
    t.index ["customer_id"], name: "index_user_authority_on_customers_on_customer_id"
    t.index ["user_id"], name: "index_user_authority_on_customers_on_user_id"
  end

  create_table "users", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "email", limit: 510, null: false
    t.string "password_digest", null: false
    t.string "organization_id", null: false
    t.binary "authority_on_organization", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

end
