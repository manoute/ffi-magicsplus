module MagPlus
  module CoreExtensions
    module NArray

      # Number of elements in a NArray instance
      def magics_total #total is a method of Array in Rubinius 
        total
      end

      # Helper to define methods that convert an Array to a FFI::MemoryPointer, filled with 
      # int, double...
      # @param [String] type ffi type for the values in array instance
      # @param [String] directive converter to binary string 
      # @example generate instance method to_C_int_array
      #   to_C_array(:int,"i") 
      def self.to_C_array(type,directive)
        define_method("to_C_#{type}_array".to_sym) do 
          FFI::MemoryPointer.new(type, self.total).write_string(self.to_s)
        end
      end
       
      # generate to_C_int_array and to_C_double_array instance methods
      # converters to C array filled with ints or doubles
      to_C_array(:int,"i")
      to_C_array(:double,"d")

      # Name of the method expected by Magics++ when setting an array
      # @example 1D array of int should be used with set1i
      #   [1, 2, 3].magics_set_name return :set1i
      def magics_set_name
        case
        when self.dim == 1 && self.typecode == 3
          :set1i
        when self.dim == 1 && self.typecode == 5
          :set1r
        when self.dim == 2 &&  self.typecode == 3 
          :set2i
        when self.dim == 2 && self.typecode == 5 
          :set2r
        when self[0].is_a?(String) 
          :set1c
        else
          raise TypeError, "This array can't be used with magics_api."
        end
      end
 
    end
  end
end

class NArray
  include(MagPlus::CoreExtensions::NArray)
end


