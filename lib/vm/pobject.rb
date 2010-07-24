module PLang
  module VM
    class PObject
      attr_reader :id
      attr_reader :params

      def initialize(id, params)
        @id = id
        @params = params
      end
    end
  end
end
