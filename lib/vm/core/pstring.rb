module PLang
  module VM
    module PFunctions
      def add_to_interpreter_string_functions
        
        def_object_message "{string: x}", :at do |object|
          plambda "{integer: y}" do |value|
            PObject.new(:char, [object.params[0][value[0].params[0]]])
          end
        end
        
        def_object_message "{string: x}", :concat do |object|
          plambda "{string: y}" do |value|
            PObject.new(:string, [object.params[0] + value[0].params[0]])
          end
        end
        
        def_object_message "x", :to_string do |object|
          plambda do |value|
            PObject.new(:string, [object.to_s])
          end
        end

        def_object_message "{string: x}", :to_integer do |object|
          plambda do |value|
            PObject.new(:integer, [object.params[0].to_i])
          end
        end

        def_object_message "{string: x}", :to_decimal do |object|
          plambda do |value|
            PObject.new(:decimal, [object.params[0].to_f])
          end
        end

        def_object_message "{string: x}", :equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :string
                PObject.new(:boolean, [(object.params[0] == value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: string"
            end
          end
        end
        
        def_object_message "{string: x}", :diff do |object|
          plambda "y" do |value|
            case value[0].id
              when :string
                PObject.new(:boolean, [(object.params[0] != value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: string"
            end
          end
        end
        
      end
    end
  end
end
