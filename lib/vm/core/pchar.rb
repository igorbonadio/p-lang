module PLang
  module VM
    module PFunctions
      def add_to_interpreter_char_functions
        def_object_message "{char: x}", :ord do |object|
          plambda do |value|
            PObject.new(:integer, [object.params[0].ord])
          end
        end

        def_object_message "{char: x}", :equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :char
                PObject.new(:boolean, [(object.params[0] == value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: char"
            end
          end
        end
        
        def_object_message "{char: x}", :diff do |object|
          plambda "y" do |value|
            case value[0].id
              when :char
                PObject.new(:boolean, [(object.params[0] != value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: char"
            end
          end
        end

      end
    end
  end
end
