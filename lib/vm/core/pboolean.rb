module PLang
  module VM
    module PFunctions
      def add_to_interpreter_boolean_functions
        
        object_message "{boolean: x}", :_and do |object|
          plambda "{boolean: y}" do |value|
            PObject.new(:boolean, [(object.params[0] and value[0].params[0])])
          end
        end
        
        object_message "{boolean: x}", :_or do |object|
          plambda "{boolean: y}" do |value|
            PObject.new(:boolean, [(object.params[0] or value[0].params[0])])
          end
        end
        
        object_message "{boolean: x}", :_not do |object|
          plambda do
            PObject.new(:boolean, [(not object.params[0])])
          end
        end
        
      end
    end
  end
end