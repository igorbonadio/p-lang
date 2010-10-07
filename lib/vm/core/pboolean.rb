module PLang
  module VM
    module PFunctions
      def add_to_interpreter_boolean_functions
        
        def_object_message "{boolean: x}", :_and do |object|
          plambda "{boolean: y}" do |value|
            PObject.new(:boolean, [(object.params[0] and value[0].params[0])])
          end
        end
        
        def_object_message "{boolean: x}", :_or do |object|
          plambda "{boolean: y}" do |value|
            PObject.new(:boolean, [(object.params[0] or value[0].params[0])])
          end
        end
        
        def_object_message "{boolean: x}", :_not do |object|
          plambda do
            PObject.new(:boolean, [(not object.params[0])])
          end
        end

        def_object_message "{boolean: x}", :equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :boolean
                PObject.new(:boolean, [(object.params[0] == value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: boolean"
            end
          end
        end
        
        def_object_message "{boolean: x}", :diff do |object|
          plambda "y" do |value|
            case value[0].id
              when :boolean
                PObject.new(:boolean, [(object.params[0] != value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: integer"
            end
          end
        end
        
      end
    end
  end
end
