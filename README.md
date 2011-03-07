ffi-magics++
============
[homepage](https://github.com/manoute/ffi-magicsplus)

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

  - After close, all parameters are reset to their default values.

** Blocks can be given to open, enabling automatic close :**

        MagPlus.open do |m|
          m.setc('output_filename','foo')
          ...
          m.coast
        end 

** Setting parameter can be done with = :**

        Magplus.subpage_upper_right_latitude = 30.0

** A hash and block can be given to methods :**
        
        # C-api like
        Magplus.setr('subpage_upper_right_latitude',30.0)
        Magplus.setr('subpage_upper_right_longitude',30.0)
        Magplus.new_subpage
        
        # Same thing with a hash
        Magplus.new_subpage({:subpage_upper_right_latitude => 30.0,
          :subpage_upper_right_longitude => 30.0})

        # Same thing with a block
        Magplus.new_subpage do |c|
          c.setr('subpage_upper_right_latitude',30.0)
          c.subpage_upper_right_longitude = 30.0
        end

** params hash is filled with the settings :**

        MagPlus.open
        MagPlus.subpage_lower_left_latitude = 30.0
        MagPlus.params #  {:subpage_lower_left_latitude => 30.0}
        MagPlus.reset_all # reset all parameters to their default value
        MagPlus.params #  {}
    
** Works with ruby array or narray :**
    
        # With Ruby array
        MagPlus.set1r("foo",[44.0, 51.0,52.0,53.0])

        # With NArray
        MagPlus.set1r("foo",NArray[44.0, 51.0,52.0,53.0])

PROBLEMS
--------

Experimental.

Only tested with Debian package and custom package on Archlinux.

Bufr not tested...working?

EXAMPLES
--------

Plotting an array of data

    require 'rubygems' # optional
    require 'ffi-magics++'

    MagPlus.open do |c|
      c.setc("output_fullname",'2D.ps')

      # Block syntax
      c.new_subpage do |sub|
        sub.subpage_lower_left_latitude = 40.0
        sub.subpage_lower_left_longitude = -10.0
        sub.subpage_upper_right_latitude = 55.0
        sub.subpage_upper_right_longitude = 10.0
      end

      # C-api syntax
      c.setr("input_field_initial_longitude",-180.0)
      c.setr("input_field_longitude_step",1.0)
      c.setr("input_field_initial_latitude",-90.0)
      c.setr("input_field_latitude_step",1.0)
      data = []
      (0..180).each {|i| data << (360.times.inject([]){|r,e| r << e})}
      c.set2r('input_field', data)

      # Hash syntax
      c.cont({:contour => 'off', :contour_label => 'off', 
        :contour_shade => 'on', :contour_shade_method => 'area_fill',
        :contour_level_count => 30})

      c.coast
    end


Using module as a mixing and plotting a grib file

    require 'rubygems' # optional
    require 'ffi-magics++'

    class Toto
      include MagPlus

      def grib_plot
        open do
          self.output_fullname = 'foo.pdf'

          grib({:grib_input_type => 'file',
                :grib_input_file_name => 'foo.grb'})

          cont({:contour => 'on', :contour_shade => 'on',
                :contour_shade_method => 'area_fill'})
          
          coast
        end
      end
    end

    Toto.new.grib_plot



For other examples, see examples directory.

REQUIREMENTS
------------
* A ruby implementation ([RVM](http://rvm.beginrescueend.com) allows to easily install, manage and work with multiple ruby environments.)
* Magics++ must be installed :

      apt-get install magics++ 

      or have a look at Magics++ installation on their homepage.

* Need 'ffi'.
* 'narray' is optionnal.
* 'rspec' for testing. 
* 'yard' to generate the doc.

INSTALL
-------

    [sudo] gem install ffi-magicsplus 

 
RUNNING SPECS/TESTS
-------------------

From the root source tree, type :

    [RUBYLIB=.:lib] rake test:all 

LICENSE
-------

(The MIT License)

Copyright (c) 2010 Mathieu Deslandes

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
