module MagPlus
  module CoreExtensions
    module Float
      # Name of the method expected by Magics++ when setting an float
      def magics_set_name
        :setr
      end
    end
  end
end

class Float
  include(MagPlus::CoreExtensions::Float)
end


