module ApplicationHelper
  def histogram(track, level, chromosome)
    hist = Histogram.where(:track_id => track).where(:level => level).where(:chromosome => chromosome)
    freq = {}
    hist.each do |h|
      freq[h.bin] = h.frequency
    end
    bin_min = hist.map(&:bin).min
    bin_max = hist.map(&:bin).max
    bin_size = 10 ** level
    data = []
    bin_min.step(bin_max, bin_size) do |bin|
      value = freq[bin].nil? ? 0 : freq[bin]
      data.push(value)
    end
    chr1_max = Histogram.where(:track_id => track).where(:level => level).where(:chromosome => "chr1").order("bin desc").limit(1)[0].bin
    width = ((300 * bin_max).to_f / chr1_max).to_i
    Gchart.line(:title => chromosome, :size => "#{width}x80", :data => data, :format => 'image_tag').html_safe
  end
end
