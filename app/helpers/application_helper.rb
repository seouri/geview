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

  def cytoband(level, chromosome, center = nil, width = 900)
    td = []
    bands = Cytoband.where(:chromosome => chromosome)
    bands.each do |b|
      band_width = ((b.end_position - b.start_position).to_f / bands.last.end_position * width).round
      band_width = 1 if band_width == 0
      td.push(content_tag(:td, b.name, {:class => b.gie_stain, :style => "width: #{band_width}px", :title => b.name}))
    end
    tr = []
    tr.push(content_tag(:tr, td.join("\n").html_safe))
    table1 = content_tag(:table, tr.join("\n").html_safe, {:class => "cytoband", :style => "width: #{width + 3}px"})
    bin_size = 10 ** level.to_i
    bin_start = center.blank? ? 0 : center.to_i - bin_size * 100
    bin_end = center.blank? ? bands.last.end_position : center.to_i + bin_size * 100
    if bin_start < 0
      bin_start = 0
    end
    if bin_end > bands.last.end_position
      bin_end = bands.last.end_position
    end
    table2 = ""
    td2 = []
    td2.push(content_tag(:td, "0", {:style => "width: #{(bin_start.to_f / bands.last.end_position * width).round}px"}))
    region_width = ((bin_end - bin_start).to_f / bands.last.end_position * width).round
    region_width = 1 if region_width == 0
    td2.push(content_tag(:td, " ", {:class => "current", :style => "width: #{region_width}px"})) if center.present?
    td2.push(content_tag(:td, "0"))
    table2 = content_tag(:table, content_tag(:tr, td2.join("\n").html_safe), {:class => "region", :style => "width: #{width + 3}px"})
    table1 + table2
  end
end
