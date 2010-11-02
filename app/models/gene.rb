class Gene < ActiveRecord::Base
  def self.region(chromosome, start_position, end_position)
    where(:chromosome => chromosome).where(["(start_position >= ? and start_position <= ?) or (end_position >= ? and end_position <= ?) or (start_position <= ? and end_position >= ?)", start_position, end_position, start_position, end_position, start_position, end_position])
  end
end
