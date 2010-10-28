class Histogram < ActiveRecord::Base
  def self.data(track, level, chromosome, center = nil)
    bin_size = 10 ** level
    bin_start = center.blank? ? nil : center.to_i - bin_size * 100
    bin_end = center.blank? ? nil : center.to_i + bin_size * 100
    hist = center.blank? ? Histogram.where(:track_id => track).where(:level => level).where(:chromosome => chromosome) : Histogram.where(:track_id => track).where(:level => level).where(:chromosome => chromosome).where(["bin >= ?", bin_start]).where(["bin <= ?", bin_end])
    freq = {}
    hist.each do |h|
      freq[h.bin] = h.frequency
    end
    bin_min = bin_start || hist.map(&:bin).min
    bin_max = bin_end || hist.map(&:bin).max
    data = []
    bin_min.step(bin_max, bin_size) do |bin|
      value = freq[bin].nil? ? 0 : freq[bin] / freq.values.max.to_f * 100
      data.push({:x => bin, :y => value})
    end
    data.to_json
  end
end
