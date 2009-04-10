# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090410200915) do

  create_table "vessels", :force => true do |t|
    t.string   "name"
    t.integer  "year"
    t.string   "service"
    t.string   "location"
    t.integer  "length",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "uscg_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "imo_number"
    t.string   "trade_indicator"
    t.string   "call_sign"
    t.string   "hull_material"
    t.string   "hull_number"
    t.string   "builder"
    t.float    "hull_depth"
    t.string   "owner"
    t.float    "hull_breadth"
    t.float    "gross_tonnage"
    t.float    "net_tonnage"
    t.string   "issuance_date"
    t.string   "expiration_date"
    t.string   "previous_names"
    t.string   "previous_owners"
  end

end
