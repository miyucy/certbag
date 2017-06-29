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

ActiveRecord::Schema.define(version: 20170629025354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "certificate_authorities", force: :cascade do |t|
    t.string "name"
    t.text "certificate"
    t.text "private_key"
    t.string "pass_phrase"
    t.bigint "serial_number", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_certificate_authorities_on_name", unique: true
  end

  create_table "client_certificates", force: :cascade do |t|
    t.string "name"
    t.text "certificate"
    t.string "pass_phrase"
    t.bigint "certificate_authority_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_authority_id"], name: "index_client_certificates_on_certificate_authority_id"
  end

  create_table "server_certificates", force: :cascade do |t|
    t.string "name"
    t.text "certificate"
    t.text "private_key"
    t.bigint "certificate_authority_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_authority_id"], name: "index_server_certificates_on_certificate_authority_id"
  end

  add_foreign_key "client_certificates", "certificate_authorities"
  add_foreign_key "server_certificates", "certificate_authorities"
end
