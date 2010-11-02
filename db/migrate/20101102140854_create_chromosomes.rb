class CreateChromosomes < ActiveRecord::Migration
  def self.up
    create_table :chromosomes do |t|
      t.string :name
      t.integer :size
    end
    add_index :chromosomes, :name
  end

  def self.down
    drop_table :chromosomes
  end
end
