# Add instance methods to Array. 
module MagPlus
  module CoreExtensions
    module Array
      # Number of elements in a 1D, 2D, 3D... array
      # @return [Fixnum]
      def magics_total #total is a method of Array in Rubinius 
        self.flatten.length
      end

      # For 2D arrays : number of elements in each dimension
      # @return [Array] 
      # @example shape of a 3x2 Array
      #   [[1,2,3],[1,2,3]].shape => [3,2]
      def shape
        return nil unless self[0].is_a? Array
        [self[0].length,self.length]
      end

      # Helper to define methods that convert an Array to a FFI::MemoryPointer, filled with 
      # int, double...
      # @param [String] type ffi type for the values in array instance
      # @param [String] directive converter to binary string 
      # @example generate instance method to_C_int_array
      #   to_C_array(:int,"i") 
      def self.to_C_array(type,directive)
        define_method("to_C_#{type}_array".to_sym) do 
          FFI::MemoryPointer.new(type, self.flatten.length).write_string(
            self.flatten.pack(directive*self.flatten.length))
        end
      end
       
      # generate to_C_int_array and to_C_double_array instance methods
      # converters to C array filled with ints or doubles
      to_C_array(:int,"i")
      to_C_array(:double,"d")
    end
  end
end

# Add methods to ARRAY to use them within magics++
class Array
  include(MagPlus::CoreExtensions::Array)
end


