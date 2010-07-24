module PLang
  module Parser
    class Node
      attr_reader :type
      def initialize(type, params)
        @type = type
        @params = params
      end

      def method_missing(name, *args)
        return @params[name]
      end

      def inspect
        ret = [@type]
        @params.each do |id, value|
          ret << value
        end
        ret
      end
    end
  end
end
