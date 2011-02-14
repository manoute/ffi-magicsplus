ffi-magics++
============

DESCRIPTION
-----------

Ruby bindings for magics++ using FFI.
[Magics++](http://www.ecmwf.int/products/data/software/magics++.html) is the latest generation of the [ECMWF](http://www.ecmwf.int)'s Meteorological plotting software 

FEATURES
--------

**Close to Magics++ C api :** just remove mag_ from C functions : 

    // With C api
    mag_open  
    mag_coast 
    ...

    # With Ruby Api
    MagPlus.open
    Magplus.coast
    ...

**Except :**

  - mag_new :

        // C api
        mag_new(superpage)
        mag_new(page)
        ...
        
        # Ruby api
        MagPlus.new_page
        MagPlus.new_super_page  
        ...

  - When setting array, there is no need to provide dimensions :

        // C api
        mag_set1i("foo",array,12) 
        
        # Ruby api
        MagPlus.set1i("foo",array) 

  - Blocks can be given to open, enabling automatic close :

        MagPlus.open do |m|
          m.setc('output_filename','foo')
          ...
          m.coast
        end 

** Works with ruby array or narray :**
    
        # With Ruby array
        MagPlus.set1r("foo",[44.0, 51.0,52.0,53.0])

        # With NArray
        MagPlus.set1r("foo",NArray[44.0, 51.0,52.0,53.0])

PROBLEMS
--------

No support for bufr.

Only tested with debian and archlinux.

Beta version.

SYNOPSIS
--------

TODO

EXEMPLES
--------

Plotting an array of data

    require 'ffi-magics++'

    MagPlus.open do |c|
      c.setc("output_fullname",'2D.ps')
      c.setc("output_format","ps")
      c.setc("page_id_line","off")
      c.setr("subpage_lower_left_latitude",40.0)
      c.setr("subpage_lower_left_longitude",-10.0)
      c.setr("subpage_upper_right_latitude",55.0)
      c.setr("subpage_upper_right_longitude",10.0)
      c.setr("map_grid_latitude_reference",0.0)
      c.setr("map_grid_longitude_reference",0.0)
      c.setr("map_grid_longitude_increment",5.0)
      c.setr("map_grid_latitude_increment",5.0)
      c.setc("map_grid_colour","black")
      c.setc("map_grid_line_style","dash")
      c.setc("map_coastline", "on")
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


Plotting a grib file

    require 'ffi-magics++'

    MagPlus.open do |c|
      c.setc("output_fullname",'foo.ps')
      c.setc("output_format","ps")
      c.setc("grib_input_type","file")
      c.setc("grib_input_file_name","foo.grb")
      c.setc("contour","on")
      c.setc("contour_label","on")
      c.setc("contour_shade","on")
      c.setc("contour_shade_method","area_fill")
      c.grib
      c.cont
      c.coast
    end

REQUIREMENTS
------------

* Magics++ must be installed :
  apt-get install magics++ 
  or have a look at Magics++ installation on their homepage.
* Need 'ffi'.
* 'narray' is optionnal.
* 'rspec' for testing. 
* 'yard' to generate the doc.

INSTALL
-------

gem install ffi-magics++ or ruby setup.rb within tarball (you may need sudo).
  
RUNNING SPECS/TESTS
-------------------

From the root source tree, type in ruby-1.9.2

    RUBYLIB=.:lib rake test:all 

LICENSE
-------

(The MIT License)

Copyright (c) 2010 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
