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

ActiveRecord::Schema[8.1].define(version: 2026_10_19_010000) do
  create_table "agents", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_agents_on_email", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_responses", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.text "body", null: false
    t.string "author_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_responses_on_ticket_id"
    t.check_constraint "author_type IN ('staff', 'customer')", name: "response_author"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "subject", null: false
    t.text "description", null: false
    t.string "customer_name", null: false
    t.string "customer_email", null: false
    t.string "priority", default: "normal", null: false
    t.string "status", default: "new", null: false
    t.integer "brand_id", null: false
    t.integer "agent_id"
    t.datetime "first_response_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_tickets_on_agent_id"
    t.index ["brand_id"], name: "index_tickets_on_brand_id"
    t.index ["status", "created_at"], name: "index_tickets_on_status_and_created_at"
    t.check_constraint "priority IN ('low', 'normal', 'high', 'urgent')", name: "ticket_priority"
    t.check_constraint "status IN ('new', 'open', 'solved')", name: "ticket_status"
  end

  add_foreign_key "ticket_responses", "tickets"
  add_foreign_key "tickets", "agents"
  add_foreign_key "tickets", "brands"
end
