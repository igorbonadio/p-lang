module PLang
  class Environment
    attr_accessor :parent

    def initialize
      @vars = Hash.new
      @parent = nil
      @object_call = Hash.new
    end

    def add_var(id, value)
      unless @vars[id]
        @vars[id] = value
      else
        raise "add_var"
      end
    end

    def get_var(id)
      v = @vars[id]
      if v
        return v
      elsif @parent
        return @parent.get_var(id)
      else
        raise "get_var"
      end
    end
        
    def add_object_call(object, msg, value)
      unless @object_call[object]
        @object_call[object] = Hash.new
      end
      @object_call[object][msg] = value
    end
    
    def get_object_call(object, msg)
      begin
        @object_call[object][msg]
      rescue
        raise "get_object_call"
      end
    end
  end
end
