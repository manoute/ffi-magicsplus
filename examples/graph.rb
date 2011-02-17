require 'ffi-magics++'

MagPlus.open do |c|
  c.setc("output_name","graph")
  c.setc("output_format","pdf")
  c.new_subpage
  c.setr("subpage_x_length",10.0)
  c.setr("subpage_y_length",10.0)
  c.setc("subpage_map_projection","cartesian")

  c.setc('axis_orientation','horizontal')
  c.setc('axis_position','bottom')
  c.setc('axis_grid','on')
  c.setc("axis_grid_colour","grey")
  c.setc("axis_grid_line_style","dash")
  c.setr("axis_min_value",0.0)
  c.setr("axis_max_value",10.0)
  c.axis

  c.setc('axis_orientation','vertical')
  c.setc('axis_position','left')
  c.setc('axis_grid','on')
  c.setr("axis_min_value",0.0)
  c.setr("axis_max_value",100.0)
  c.axis

  x=[]
  y=[]
  y2=[]
  (0..10).each do |v|
    x << v
    y << v*v
    y2 << v + 20.0
  end

  c.setc("graph_type","area")
  c.setc("graph_line_colour","red")
  c.set1r("graph_curve_x_values",x)
  c.set1r("graph_curve_y_values",y)
  c.set1r("graph_curve2_x_values",x)
  c.set1r("graph_curve2_y_values",y2)
  c.graph
end
