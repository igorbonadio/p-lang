module PLang
  module VM
    module PFunctions
      def add_to_interpreter_string_functions
        
        object_message "{string: x}", :at do |object|
          plambda "{integer: y}" do |value|
            PObject.new(:char, [object.params[0][value[0].params[0]]])
          end
        end
        
        object_message "{string: x}", :concat do |object|
          plambda "{string: y}" do |value|
            PObject.new(:string, [object.params[0] + value[0].params[0]])
          end
        end
        
        object_message "x", :to_s do |object|
          plambda do |value|
            PObject.new(:string, [object.to_s])
          end
        end
        
      end
    end
  end
end
