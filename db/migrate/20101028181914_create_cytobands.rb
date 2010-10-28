class CreateCytobands < ActiveRecord::Migration
  def self.up
    create_table :cytobands do |t|
      t.string :chromosome, :limit => 5
      t.integer :start_position
      t.integer :end_position
      t.string :name, :limit => 7
      t.string :gie_stain, :limit => 7
    end
    add_index :cytobands, [:chromosome, :start_position]
    add_index :cytobands, [:chromosome, :end_position]
  end

  def self.down
    drop_table :cytobands
  end
end
