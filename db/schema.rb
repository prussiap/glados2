# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140411153641) do

  create_table "agreement_executions", :force => true do |t|
    t.integer  "person_id",     :null => false
    t.integer  "agreement_id",  :null => false
    t.date     "date_signed",   :null => false
    t.string   "agreement_url", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "agreements", :force => true do |t|
    t.string  "name",    :null => false
    t.string  "author",  :null => false
    t.integer "version", :null => false
  end

  create_table "door_keys", :force => true do |t|
    t.integer  "person_id",  :null => false
    t.integer  "door_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "doors", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "equipment", :force => true do |t|
    t.string   "model",            :null => false
    t.string   "make",             :null => false
    t.string   "serial_number"
    t.integer  "replacement_cost"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "fobs", :force => true do |t|
    t.string   "key",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "person_id"
  end

  create_table "people", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "possession_contracts", :force => true do |t|
    t.integer  "person_id",     :null => false
    t.integer  "equipment_id",  :null => false
    t.string   "contract_type", :null => false
    t.integer  "payment_cents"
    t.date     "expires"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "start_date"
  end

end
