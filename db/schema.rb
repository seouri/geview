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

ActiveRecord::Schema.define(:version => 20101102140854) do

  create_table "chromosomes", :force => true do |t|
    t.string  "name"
    t.integer "size"
  end

  add_index "chromosomes", ["name"], :name => "index_chromosomes_on_name"

  create_table "cytobands", :force => true do |t|
    t.string  "chromosome",     :limit => 5
    t.integer "start_position"
    t.integer "end_position"
    t.string  "name",           :limit => 7
    t.string  "gie_stain",      :limit => 7
  end

  add_index "cytobands", ["chromosome", "end_position"], :name => "index_cytobands_on_chromosome_and_end_position"
  add_index "cytobands", ["chromosome", "start_position"], :name => "index_cytobands_on_chromosome_and_start_position"

  create_table "genes", :force => true do |t|
    t.string  "symbol"
    t.string  "name"
    t.string  "chromosome"
    t.string  "strand",                :limit => 1
    t.integer "start_position"
    t.integer "end_position"
    t.integer "coding_start_position"
    t.integer "coding_end_position"
    t.integer "exon_count"
    t.text    "exon_start_positions"
    t.text    "exon_end_positions"
  end

  add_index "genes", ["chromosome", "end_position"], :name => "index_genes_on_chromosome_and_end_position"
  add_index "genes", ["chromosome", "start_position"], :name => "index_genes_on_chromosome_and_start_position"

  create_table "histograms", :force => true do |t|
    t.integer "track_id",   :limit => 2
    t.integer "level",      :limit => 1
    t.string  "chromosome", :limit => 5
    t.integer "bin"
    t.integer "frequency"
  end

  add_index "histograms", ["level", "chromosome", "bin"], :name => "index_histograms_on_level_and_chromosome_and_bin"
  add_index "histograms", ["track_id", "level", "chromosome", "bin"], :name => "index_histograms_on_track_id_and_level_and_chromosome_and_bin"

  create_table "tracks", :force => true do |t|
    t.string "name"
  end

end
