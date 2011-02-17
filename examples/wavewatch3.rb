require 'ffi-magics++'
require 'open-uri'
require 'date'

class WW3
  include MagPlus

  def host
    'ftpprd.ncep.noaa.gov'
  end
  
  def path
    'pub/data/nccf/com/wave/prod/wave.' +
    Date.today.strftime('%Y%m%d') + 
    '/multi_1.glo_30m.t00z.f000.grib2'
  end 

  def url 
    URI::FTP.build({:host => host, :path => path})
  end
  
  def fetch_grib_file
    puts "Downloading Wave Watch III grib file (today, 00h)...\n" +
      "See http://polar.ncep.noaa.gov/waves/"
    
    data = url.read
    File.open('ww3.grib2','w') {|f| f.write data} 
    puts "File downloaded and saved to ww3.grib2"
  end
  
  def plot_grib_file
    open do 
      # Output
      setc("output_fullname",'ww3.pdf')
      setc("output_format","pdf")

      # Projection
      setc('subpage_map_projection','polar_stereographic')

      # Grid and coast
      setr("subpage_lower_left_latitude",20.0)
      setr("subpage_lower_left_longitude",-40.0)
      setr("subpage_upper_right_latitude",70.0)
      setr("subpage_upper_right_longitude",10.0)
      setr("map_grid_latitude_reference",0.0)
      setr("map_grid_longitude_reference",0.0)
      setr("map_grid_longitude_increment",5.0)
      setr("map_grid_latitude_increment",5.0)
      setc("map_grid_colour","black")
      setc("map_grid_line_style","dash")
      setc("map_coastline_land_shade", "on")
      setc("map_coastline_land_shade_colour", "grey")

      # Grib file and field selection
      setc("grib_input_type","file")
      setc("grib_input_file_name","ww3.grib2")
      seti("grib_field_position",5)
      grib

      # Contour
      setc("contour","on")
      seti('contour_line_thickness', 1)
      setc('contour_line_colour', 'black')
      setc("contour_highlight",'off')
      setc("contour_label","on")
      
      setc("contour_level_selection_type","level_list")
      wave_level_list = [0.0, 0.5, 1.25, 2.5, 4.0, 6.0, 9.0, 14.0, 999.0]
      set1r('contour_level_list', wave_level_list)

      setc("contour_shade","on")
      setc("contour_shade_method","area_fill")

      setc("contour_shade_colour_method","list")
      wave_level_colors = [60, 40, 100, 190, 240, 280, 300, 0].
       each.inject([]) {|e,v| e << "HSL(#{v},0.5,0.5)"}
      set1c('contour_shade_colour_list', wave_level_colors)

      cont
      coast
    end
  end
end

toto = WW3.new
toto.fetch_grib_file
toto.plot_grib_file

