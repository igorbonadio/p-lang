module PLang
  module VM
    class PObject
      attr_reader :id
      attr_accessor :params

      def initialize(id, params)
        @id = id
        @params = params
      end

      def to_s
        case @id
          when :integer, :decimal, :char, :string, :boolean
            return params[0]
          else
            str = "{#{@id}"
            if @params.length > 0
              str += ": "
              @params.each do |param|
                str += "#{param.to_s}, "
              end
              str[-2] = "}"
              str
            else
              str += "}"
            end
            str.strip
        end
      end
    end
  end
end
