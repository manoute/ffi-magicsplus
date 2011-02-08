# Methods to add to a FFI::MemoryPointer in rubinius
module MagPlus
  module CoreExtensions
    module MemoryPointer
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      # Write an array of pointer in a MemoryPointer instance
      def write_array_of_pointer(ary)
        ary.each_with_index do |v,i|
          self[i].write_long v.address #:pointer et :long? (no write_pointer in rubinius?)
        end
      end

      module ClassMethods
        # Create a new instance of MemoryPointer pointing to a string 
        # @param [String] s
        # @return a new memory pointer
        def from_string(s)
          ptr = self.new(s.bytesize + 1, 1, false)
          ptr.write_string(s + '\0') # Is \0 necessary?
          ptr
        end
      end
    end
  end 
end


# Add methods to FFI::MemoryPointer in rubinius
class FFI::MemoryPointer
  include(MagPlus::CoreExtensions::MemoryPointer) unless respond_to?(:from_string)
end
