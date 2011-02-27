require 'ffi'
require 'ffi-magics++/core_ext/array'
require 'ffi-magics++/core_ext/narray'
require 'ffi-magics++/core_ext/integer'
require 'ffi-magics++/core_ext/float'
require 'ffi-magics++/core_ext/string'
require 'ffi-magics++/core_ext/memorypointer'

# Wrapper for Magics++ C api using ffi.
module MagPlus
  VERSION = '0.1.1'
  extend self
  extend FFI::Library
  ffi_lib ["MagPlus","libMagPlus"]

  # raw wrapper for C api
  begin
    attach_function 'mag_open', [], :void
    attach_function 'mag_close', [], :void
    attach_function 'mag_grib', [], :void
    attach_function 'mag_coast', [], :void
    attach_function 'mag_cont', [], :void
    attach_function 'mag_test', [], :void
    attach_function 'mag_odb', [], :void

    attach_function 'mag_import', [], :void
    attach_function 'mag_netcdf', [], :void
    attach_function 'mag_obs', [], :void
    attach_function 'mag_raw', [], :void
    attach_function 'mag_image', [], :void
    attach_function 'mag_plot', [], :void
    attach_function 'mag_text', [], :void
    attach_function 'mag_wind', [], :void
    attach_function 'mag_symb', [], :void
    attach_function 'mag_boxplot', [], :void

    attach_function 'mag_pie', [], :void
    attach_function 'mag_graph', [], :void
    attach_function 'mag_axis', [], :void
    attach_function 'mag_geo', [], :void
    attach_function 'mag_eps', [], :void
    attach_function 'mag_print', [], :void
    attach_function 'mag_info', [], :void

    attach_function 'mag_new', [:string], :void

    attach_function 'mag_setc', [:string,:string], :void

    attach_function 'mag_setr', [:string,:double], :void

    attach_function 'mag_seti', [:string,:int], :void

    attach_function 'mag_setp', [:string,:pointer], :void

    attach_function 'mag_set1c', [:string,:pointer,:int], :void

    attach_function 'mag_set1i', [:string,:pointer,:int], :void
    attach_function 'mag_set2i', [:string,:pointer,:int,:int], :void
    attach_function 'mag_set3i', [:string,:pointer,:int,:int,:int], :void

    attach_function 'mag_set1r', [:string,:pointer,:int], :void
    attach_function 'mag_set2r', [:string,:pointer,:int,:int], :void
    attach_function 'mag_set3r', [:string,:pointer,:int,:int,:int], :void

    attach_function 'mag_reset', [:string], :void

    attach_function 'mag_act', [:string,:string,:string], :void

    attach_function'mag_bufr', [], :void # need EmosLib...

  rescue FFI::NotFoundError => e
    p "WARNING !!! #{e.message}"
  end

  # Allow blocs with open
  # @return [self]
  def open
    mag_open
    if block_given?
      begin
        yield self
        mag_close
      rescue StandardError => e
        puts e.message
      end
    end
    self
  end

  # For setting 1-dimensional double array arguments
  # @param [String] str parameter value
  # @param [Array,NArray, ...] ary 1D double array,  
  #   any object that implements :to_C_double_array and :magics_total
  #   (for an example, see {file:lib/ffi-magics++/core_ext/array.rb array.rb})
  # @see Array#to_C_array
  # @return [self]
  def set1r(str,ary)
    raise TypeError, 
      "#{ary.class} doesn't respond to :to_C_double_array and :magics_total" unless 
        (ary.respond_to? :to_C_double_array) && (ary.respond_to? :magics_total)
    mag_set1r(str,ary.to_C_double_array,ary.magics_total)
    self
  end

  # For setting 2-dimensional double array arguments
  # @param [String] str parameter value
  # @param [Array,NArray, ...] ary 2D double array,  
  #   any object that implements :to_C_double_array and :shape
  #   (for an example, see {file:lib/ffi-magics++/core_ext/array.rb array.rb})
  # @return [self]
  def set2r(str,ary)
    raise TypeError, 
      "#{ary.class} doesn't respond to :to_C_double_array and :shape" unless 
        (ary.respond_to? :to_C_double_array) && (ary.respond_to? :shape)
    mag_set2r(str,ary.to_C_double_array,ary.shape[0],ary.shape[1])
    self
  end

  # For setting 1-dimensional integer array arguments
  # @param [String] str parameter value
  # @param [Array,NArray, ...] ary 1D integer array,  
  #   any object that implements :to_C_int_array and :magics_total
  #   (for an example, see {file:lib/ffi-magics++/core_ext/array.rb array.rb})
  # @return [self]
  def set1i(str,ary)
    raise TypeError, 
      "#{ary.class} doesn't respond to :to_C_int_array and :magics_total" unless 
        (ary.respond_to? :to_C_int_array) && (ary.respond_to? :magics_total)
    mag_set1i(str,ary.to_C_int_array,ary.magics_total)
    self
  end

  # For setting 2-dimensional integer array arguments
  # @param [String] str parameter value
  # @param [Array,NArray, ...] ary 2D integer array,  
  #   any object that implements :to_C_int_array and :magics_total
  #   (for an example, see {file:lib/ffi-magics++/core_ext/array.rb array.rb})
  # @return [self]
  def set2i(str,ary)
    raise TypeError, 
      "#{ary.class} doesn't respond to :to_C_int_array and :shape" unless 
        (ary.respond_to? :to_C_int_array) && (ary.respond_to? :shape)
    mag_set2i(str,ary.to_C_int_array,ary.shape[0],ary.shape[1])
    self
  end
  
  # For setting 1-dimensional integer array arguments
  # @param [String] str parameter value
  # @param [Array] ary 1D string array,  
  # @return [self]
  def set1c(str,sa)
    strptrs = []
    sa.each do |s|
      strptrs << FFI::MemoryPointer.from_string(s)
    end
    sa_ptr= FFI::MemoryPointer.new(:pointer, sa.length)
    sa_ptr.write_array_of_pointer(strptrs)
    mag_set1c(str,sa_ptr,sa.length)
    self
  end

  # generate foo method, equivalent method to mag_foo, but returning self
  # except for mag_new and methods that are already defined (set1r...)
  self.methods.each do |f|
    if f =~ /^mag_(.*)$/ && !self.respond_to?($1.to_sym) && $1 != 'new'
      define_method($1.to_sym) do |*args|
        hash,*rest = *args
        if hash.respond_to? :each_pair
          hash.each_pair do |k,v|
            send(v.magics_set_name.to_sym,k.to_s,v)
          end
        else
          rest = args
        end
        send(f.to_sym,*rest)
        self
      end
    end
  end
  
  # mag_new equivalent methods returning self
  # mag_new("page") => new_page
  # mag_new("subpage") => new_subpage
  # mag_new("super_page") => new_super_page
  %W{page subpage super_page}.each do |p|
    define_method("new_#{p}".to_sym) do 
      send(:mag_new,p)
      self
    end
  end
end

