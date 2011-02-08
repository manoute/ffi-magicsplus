require 'ffi-magics++'
require 'fileutils'
require 'rspec/core/rake_task'

namespace :test do 
  class << MagPlus
    def basic_plot
      %W{contour_level_list contour_shade_colour_list symbol_input_x_position 
        contour_level_selection_type contour_shade_method contour_shade_colour_method 
        contour_shade_colour_list
        symbol_input_y_position symbol_input_marker_list}.each do |str|
        reset(str)
      end
      setc("output_format","ps")
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
  end

  desc "Generate data then run rspec"
  task :all => [:data_for_rspec, :spec]

  desc "Generate postscript files needed for testing with rspec"
  task :data_for_rspec => [:z500, :twodim, :symb, :mv_files_to_spec_datadir]
  
  desc "Run specs"
  RSpec::Core::RakeTask.new 

  desc "Generate z500.ps"
  task :z500 do |t|
    MagPlus.open do |c|
      c.setc("output_fullname",'z500.ps')
      c.basic_plot
      c.setc("grib_input_type","file")
      c.setc("grib_input_file_name","spec/data/z500.grb")
      c.setc("contour_level_selection_type","level_list")
      c.setc("contour","on")
      c.setc("contour_label","on")
      c.setc("contour_shade","on")
      c.setc("contour_shade_method","area_fill")
      c.setc("contour_shade_colour_method","list")
      color_list = []
      (-230..0).step(6) do |x|
        color_list << "HSL(#{-x},0.4,0.5)"
      end
      c.set1r("contour_level_list",
        (530..569).inject([]) {|a,e| a << e })
      c.set1c("contour_shade_colour_list",color_list)
      c.grib
      c.cont
      c.coast
    end
  end

  desc "Generate 2D.ps"
  task :twodim do |t|
    MagPlus.open do |c|
      c.setc("output_fullname",'2D.ps')
      c.basic_plot
      c.setr("input_field_initial_longitude",-180.0)
      c.setr("input_field_longitude_step",1.0)
      c.setr("input_field_initial_latitude",-90.0)
      c.setr("input_field_latitude_step",1.0)
      data = []
      (0..180).each {|i| data << (360.times.inject([]){|r,e| r << e})}
      c.set2r('input_field', data)
      c.setc("contour","off")
      c.setc("contour_label","off")
      c.setc("contour_shade","on")
      c.setc("contour_shade_method","area_fill")
      c.seti("contour_level_count",30)
      c.cont
      c.coast
    end
  end 

  desc "Generate symb.ps"
  task :symb do |t|
    MagPlus.open do |c|
      c.setc("output_fullname",'symb.ps')
      c.basic_plot
      c.setc("symbol_type","marker")
      c.set1r("symbol_input_x_position",[1.0, 2.0, 3.0,4.0])
      c.set1r("symbol_input_y_position",[44.0, 51.0,52.0,53.0])
      c.set1i("symbol_input_marker_list",[3,3,3,3])
      c.setr("symbol_height",1.0)
      c.symb
      c.coast
    end
  end 

  desc "Move postscript files to spec/data"
  task :mv_files_to_spec_datadir do
    %w{z500.ps 2D.ps symb.ps}.each do |f|
      FileUtils.mv f, './spec/data/'
    end
  end
end
