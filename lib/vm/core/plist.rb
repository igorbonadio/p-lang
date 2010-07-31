module PLang
  module VM
    module PFunctions
      def add_to_interpreter_list_functions

        def_object_message "{list: x, xs}", :head do |object|
          plambda do |value|
            object.params[0]
          end
        end

        def_object_message "{list: x, xs}", :tail do |object|
          plambda do |value|
            object.params[1]
          end
        end

        def_object_message "{list: x, xs}", :concat do |object|
          plambda "x" do |value|
            PObject.new(:list, [value[0], object])
          end
        end

        def_object_message "{empty}", :concat do |object|
          plambda "x" do |value|
            PObject.new(:list, [value[0], object])
          end
        end

      end
    end
  end
end
