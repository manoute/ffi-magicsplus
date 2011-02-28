module MagPlus
  module CoreExtensions
    module Integer
      # Name of the method expected by Magics++ when setting an integer
      def magics_set_name
        :seti
      end
 
    end
  end
end

class Integer
  include(MagPlus::CoreExtensions::Integer)
end


