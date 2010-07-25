module PLang
  module VM
    class Environment
      attr_accessor :parent
      
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
        v = @vars[id]
        if v
          return v
        elsif @parent
          return @parent.get_var(id)
        else
          raise "TODO: Environment#get_var"
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
                  set_var(param.value, object.params[i])
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
