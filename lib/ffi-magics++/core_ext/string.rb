module MagPlus
  module CoreExtensions
    module String
      # Name of the method expected by Magics++ when setting an string
      def magics_set_name
        :setc
      end
 
    end
  end
end

class String
  include(MagPlus::CoreExtensions::String)
end


