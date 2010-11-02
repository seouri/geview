class CreateGenes < ActiveRecord::Migration
  def self.up
    create_table :genes do |t|
      t.string :symbol
      t.string :name
      t.string :chromosome
      t.string :strand, :limit => 1
      t.integer :start_position
      t.integer :end_position
      t.integer :coding_start_position
      t.integer :coding_end_position
      t.integer :exon_count
      t.text :exon_start_positions
      t.text :exon_end_positions
    end
    add_index :genes, [:chromosome, :start_position]
    add_index :genes, [:chromosome, :end_position]
  end

  def self.down
    drop_table :genes
  end
end
