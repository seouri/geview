class CreateHistograms < ActiveRecord::Migration
  def self.up
    create_table :histograms do |t|
      t.integer :track_id, :limit => 2
      t.integer :level, :limit => 1
      t.string :chromosome, :limit => 5
      t.integer :bin
      t.integer :frequency
    end
    add_index :histograms, [:track_id, :level, :chromosome, :bin]
    add_index :histograms, [:level, :chromosome, :bin]
  end

  def self.down
    drop_table :histograms
  end
end
