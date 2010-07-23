module PLang
  module VM
    class Token
      attr_accessor :value
      attr_accessor :type
      attr_accessor :line
      attr_accessor :i
      attr_accessor :src

      def initialize(type)
        @type = type
      end

      def to_s
        "\#{#{type.to_s}: #{value}}"
      end
    end
  end
end
