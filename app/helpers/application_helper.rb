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
    x_axis_label = []
    bin_min.step(bin_max, bin_size) do |bin|
      value = freq[bin].nil? ? 0 : freq[bin]
      data.push(value)
      x_label = (bin / bin_size) % 100 == 0 ? bin / bin_size : ""
      x_axis_label.push(x_label)
    end
    y_axis_max = hist.map(&:frequency).max
    chr1_max = Histogram.where(:track_id => track).where(:level => level).where(:chromosome => "chr1").order("bin desc").limit(1)[0].bin
    width = ((100 * bin_max).to_f / chr1_max).to_i
    Gchart.line(:title => chromosome, :size => "#{width}x50", :data => data, :format => 'image_tag').html_safe
  end

  def chromosome_nav(chromosome = 1)
    li = []
    ((1 .. 22).to_a + ["X", "Y"]).each do |c|
      el = c.to_s == chromosome.gsub(/^chr/, "") ? "<span class=\"current\">#{c}</span>" : link_to(c, graph_path(:level => 6, :chromosome => c, :center => nil))
      li.push(content_tag(:li, el.html_safe))
    end
    ul = content_tag(:ul, li.join("\n").html_safe).html_safe
    content_tag(:div, ul, :id => "chromosome_nav").html_safe
  end

  def zoom_control(level, chromosome)
    text = "<span>Zoom out (#{number_to_human(10 ** level.to_i)} bases)</span>"
    if level != 6
      text = link_to("Zoom out (#{number_to_human(10 ** level.to_i)} bases)", graph_path(:level => level + 1, :chromosome => chromosome.gsub(/^chr/, ""), :center => (level == 5 ? nil : @center)))
    end
    content_tag(:div, text.html_safe, :id => "zoom_control").html_safe
  end
end
