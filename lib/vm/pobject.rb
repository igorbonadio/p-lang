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
            return params[0].to_s
          when :empty
            return "'()"
          when :list
            str = "'("
            params = @params
            ok = false
            while params and params != []
              str += "#{params[0].to_s}, "
              params = params[1].params
              ok = true
            end
            if ok
              str[-2] = ')'
            else
              str += ')'
            end
            return str.strip
          else
            str = "{#{@id}"
            if @params.length > 0
              str += ": "
              @params.each do |param|
                str += "#{param.to_s}, "
              end
              str[-2] = "}"
            else
              str += "}"
            end
            return str.strip
        end
      end
    end
  end
end
