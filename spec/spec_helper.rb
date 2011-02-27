require 'rspec' 
require 'ffi-magics++'

def narray_installed
  begin
    require 'narray'
    true
  rescue LoadError
    puts "\nnarray not found, narray tests won't be run."
    false
  end
end

class << MagPlus
  def plot_basic(file_name)
    %W{contour_level_list contour_shade_colour_list symbol_input_x_position 
      contour_level_selection_type contour_shade_method contour_shade_colour_method 
      contour_shade_colour_list
      symbol_input_y_position symbol_input_marker_list}.each do |str|
      reset(str)
    end
    setc("output_format","ps")
    setc("output_fullname",file_name)
    setc("page_id_line","off")
    setr("subpage_lower_left_latitude",40.0)
    setr("subpage_lower_left_longitude",-10.0)
    setr("subpage_upper_right_latitude",55.0)
    setr("subpage_upper_right_longitude",10.0)
    setr("map_grid_latitude_reference",0.0)
    setr("map_grid_longitude_reference",0.0)
    setr("map_grid_longitude_increment",5.0)
    setr("map_grid_latitude_increment",5.0)
    setc("map_grid_colour","black")
    setc("map_grid_line_style","dash")
    setc("map_coastline", "on")
  end

  def plot_grib(input_file) 
    setc("grib_input_type","file")
    setc("grib_input_file_name",input_file)
    setc("contour_level_selection_type","level_list")
    setc("contour","on")
    setc("contour_label","on")
    setc("contour_shade","on")
    setc("contour_shade_method","area_fill")
    setc("contour_shade_colour_method","list")
    color_list = []
    (-230..0).step(6) do |x|
      color_list << "HSL(#{-x},0.4,0.5)"
    end
    yield
    set1c("contour_shade_colour_list",color_list)
    grib
    cont
    coast
  end

  def plot2D
    setr("input_field_initial_longitude",-180.0)
    setr("input_field_longitude_step",1.0)
    setr("input_field_initial_latitude",-90.0)
    setr("input_field_latitude_step",1.0)
    yield
    setc("contour","off")
    setc("contour_label","off")
    setc("contour_shade","on")
    setc("contour_shade_method","area_fill")
    seti("contour_level_count",30)
    cont
    coast
  end

end


