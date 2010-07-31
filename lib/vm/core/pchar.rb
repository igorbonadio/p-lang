module PLang
  module VM
    module PFunctions
      def add_to_interpreter_char_functions
        def_object_message "{char: x}", :ord do |object|
          plambda do |value|
            PObject.new(:integer, [object.params[0].ord])
          end
        end
      end
    end
  end
end
