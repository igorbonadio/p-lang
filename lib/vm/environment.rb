module PLang
  module VM
    class Environment
      def initialize
        @vars = Hash.new
      end

      def set_var(id, value)
        unless @vars[id]
          @vars[id] = value
        else
          raise "TODO: Environment"
        end
      end

      def get_var(id)
        @vars[id]
      end
    end
  end
end
