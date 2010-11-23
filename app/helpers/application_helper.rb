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

  def chromosome_nav(chromosome = "")
    li = []
    ((1 .. 22).to_a + ["X", "Y"]).each do |c|
      el = c.to_s == chromosome.gsub(/^chr/, "") ? "<span class=\"current\">#{c}</span>" : link_to(c, graph_path(:level => 6, :chromosome => c, :center => nil))
      li.push(content_tag(:li, el.html_safe))
    end
    ul = content_tag(:ul, li.join("\n").html_safe).html_safe
    content_tag(:div, ul, :id => "chromosome_nav").html_safe
  end

  def zoom_control(level, chromosome)
    text = "<span>Zoom out (#{number_to_human(10 ** level.to_i)} base-bin)</span>"
    if level != 6
      text = link_to("Zoom out (#{number_to_human(10 ** level.to_i)} base-bin)", graph_path(:level => level + 1, :chromosome => chromosome.gsub(/^chr/, ""), :center => (level == 5 ? nil : @center)))
    end
    content_tag(:div, text.html_safe, :id => "zoom_control").html_safe
  end

  def cytoband(level, chromosome, center = nil, width = 900)
    td = []
    bands = Cytoband.where(:chromosome => chromosome)
    bands.each do |b|
      band_width = ((b.end_position - b.start_position).to_f / bands.last.end_position * width).round
      band_width = 1 if band_width == 0
      td.push(content_tag(:td, " ", {:class => b.gie_stain, :style => "width: #{band_width}px", :title => b.name}))
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
    td2.push(content_tag(:td, " ", {:class => "current", :style => "width: #{region_width}px", :title => "#{number_with_delimiter(bin_start)}-#{number_with_delimiter(bin_end)}"})) if center.present?
    td2.push(content_tag(:td, "0"))
    table2 = content_tag(:table, content_tag(:tr, td2.join("\n").html_safe), {:class => "region", :style => "width: #{width + 3}px"})
    mark_info = " <small>(mouse-over for cytoband name)</small>"
    mark_info = " <small>(current region marked with red box)</small>" if center.present?
    cytoband = "<h2>Cytobands#{mark_info}</h2>" + table1 + table2
    cytoband.html_safe
  end

  def genes(level, chromosome, center = nil, width = 900)
    track = "<h2>Genes</h2> <p>(Genes will be displayed when zoomed in. Click on the bar to zoom in)</p>"
    if level < 6 and center.present?
      bin_size = 10 ** level.to_i
      bin_start = center.to_i - bin_size * 100
      bin_end = center.to_i + bin_size * 100
      if bin_start < 0
        bin_start = 0
      end
      if bin_end > Chromosome.where(:name => chromosome).first.size
        bin_end = Chromosome.where(:name => chromosome).first.size
      end
      genes = Gene.region(chromosome, bin_start, bin_end).map do |g|
        s = g.start_position < bin_start ? bin_start : g.start_position
        e = g.end_position > bin_end ? bin_end : g.end_position
        {:x1 => s, :x2 => e, :symbol => g.symbol, :name => g.name}
      end
      track  = <<END
<h2>Genes <small>(mouse over for gene symbol & name)</small></h2>
<div id="genes">
<script type="text/javascript+protovis">
var genes = #{genes.to_json};
var w = 900,
    h = 10,
    x = pv.Scale.linear(#{bin_start}, #{bin_end}).range(0, w),
    y = pv.Scale.linear(0, 100).range(0, h);
 
/* The root panel. */
var vis = new pv.Panel()
    .width(w)
    .height(h)
    .bottom(0)
    .left(30)
    .right(30)
    .top(5);

vis.add(pv.Panel)
.data(genes)
.add(pv.Bar)
  .top(function() 0)
  .height(10)
  .left(function(d) x(d.x1))
  .width(function(d) x(d.x2) - x(d.x1))
  .def("fillStyle", pv.rgb(128, 128, 128, 0.5))
  .event("click", function(d) self.location = "/graph/" + chromosome + "/" + zoom_in_level + "/" + d.x.toString())
  .title(function(d) d.symbol + ": " + d.name);

  vis.add(pv.Rule)
      .bottom(0)
      .strokeStyle("#000");

vis.render();
</script>
</div>
END
    end
    track.html_safe
  end
end
