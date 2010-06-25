module PLang
  class Environment
    attr_accessor :parent

    def initialize
      @vars = Hash.new
      @parent = nil
    end

    def add(id, value)
      unless @vars[id]
        @vars[id] = value
      else
        raise "add"
      end
    end

    def get(id)
      v = @vars[id]
      if v
        return v
      elsif @parent
        return @parent.get(id)
      else
        raise "get"
      end
    end
  end
end
