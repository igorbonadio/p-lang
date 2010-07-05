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
        
    def add_object_call(form, msg, value)
      unless @object_call[msg]
        @object_call[msg] = Hash.new
      end
      @object_call[msg][form] = value
    end
    
    def get_object_call(object, msg)
      begin
        lamb = []
        @object_call[msg].each do |obj|
          if obj[0][1] == object.type
            lamb |= obj[1]
          end
        end
        return lamb
      rescue
        raise "get_object_call"
      end
    end
  end
end
