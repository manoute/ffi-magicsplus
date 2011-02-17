require 'ffi-magics++'
require 'narray'

MagPlus.open do |c|
  c.setc("output_format","pdf")
  c.setc("output_name",'narray')
  c.setc("page_id_line","off")
  c.setr("map_grid_latitude_reference",0.0)
  c.setr("map_grid_longitude_reference",0.0)
  c.setr("map_grid_longitude_increment",20.0)
  c.setr("map_grid_latitude_increment",20.0)
  c.setc("map_grid_colour","black")
  c.setc("map_grid_line_style","dash")
  c.setc("map_coastline", "on")
  c.setr("input_field_initial_longitude",-180.0)
  c.setr("input_field_longitude_step",1.0)
  c.setr("input_field_initial_latitude",-90.0)
  c.setr("input_field_latitude_step",1.0)
  c.setc("contour","off")
  c.setc("contour_label","off")
  c.setc("contour_shade","on")
  c.setc("contour_shade_method","area_fill")
  c.seti("contour_level_count",30)

  data=NArray.float(360,181)
  (0..359).each do |x|
    (0..180).each {|y| data[x,y] = NMath::sin(x*Math::PI/90.0)*NMath::cos(y*Math::PI/180.0)}
  end
  c.set2r('input_field', data)
  c.cont
  c.coast
end
