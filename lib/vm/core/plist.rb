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

        def_object_message "{list: x, xs}", :length do |object|
          plambda do |value|
            if object.params[0] != :empty
              i = 1
              tail = object.params[1]
              while tail.id != :empty
                tail = tail.params[1]
                i += 1
              end
              PObject.new(:integer, [i])
            else
              PObject.new(:integer, [0])
            end
          end
        end

        def_object_message "{empty}", :length do |object|
          plambda do |value|
            PObject.new(:integer, [0])
          end
        end

      end
    end
  end
end
