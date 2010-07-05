module PLang
  class PObject
    attr_accessor :type
    attr_accessor :params
    
    def initialize(type, params)
      @type = type
      @params = params
    end
    
    def ==(obj)
      if @type == obj.type
        @params.each_with_index do |param, i|
          unless param == obj.params[i]
            return false
          end
        end
        return true
      else
        return false
      end
    end
    
    def form
      case @type
        when :integer, :decimal, :boolean
          [:literal, @type, @params[0]]
        else
          [:object, @type, @params.collect(&:form)]
      end
    end
    
  end
end