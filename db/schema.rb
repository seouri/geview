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

ActiveRecord::Schema.define(:version => 20101027155920) do

  create_table "histograms", :force => true do |t|
    t.integer "track_id",   :limit => 2
    t.integer "level",      :limit => 1
    t.string  "chromosome", :limit => 5
    t.integer "bin"
    t.integer "frequency"
  end

  add_index "histograms", ["track_id", "level", "chromosome", "bin"], :name => "index_histograms_on_track_id_and_level_and_chromosome_and_bin"

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
