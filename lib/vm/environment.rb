module PLang
  module VM
    class Environment
      attr_accessor :parent
      
      def initialize
        @vars = Hash.new
        @objects = Hash.new
      end

      def set_var(id, value)
        unless @vars[id]
          @vars[id] = value
        else
          raise "LetError: TODO"
        end
      end

      def get_var(id)
        v = @vars[id]
        if v
          return v
        elsif @parent
          return @parent.get_var(id)
        else
          raise "NameError: undefined variable '#{id}'"
        end
      end
      
      #TODO: new operator to add lambdas
      def add_lambda(id, lamb)
        v = get_var(id)
        if v
          if v.id == :lambda
            v.params |= lamb.params
          else
            raise "TODO: Environment#add_lambda#2"
          end
        else
          raise "TODO: Environment#add_lambda#1"
        end
      end
      
      def set_object_var(form, object)
        if form.type == :object
          if form.id.value == object.id
            form.params.each_with_index do |param, i|
              case param.type 
                when :object
                  set_object_var(param, object.params[i])
                when :id
                  unless param.value == :_
                    if object.id == :integer
                      set_var(param.value, PObject.new(:integer, [object.params[i]]))
                    elsif object.id == :decimal
                      set_var(param.value, PObject.new(:decimal, [object.params[i]]))
                    elsif object.id == :char
                      set_var(param.value, PObject.new(:char, [object.params[i]]))
                    elsif object.id == :string
                      set_var(param.value, PObject.new(:string, [object.params[i]]))
                    else
                      set_var(param.value, object.params[i])
                    end
                  end
                else
                  unless param.value == object.params[i].params[0]
                    raise "TODO: Environment#set_object_var#3"
                  end
              end
            end
          else
            raise "TODO: Environment#set_object_var#1"
          end
        else
          raise "TODO: Environment#set_object_var#2"
        end
      end
    end
  end
end
