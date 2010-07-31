module PLang
  module VM
    module PFunctions
      def add_to_interpreter_integer_functions
        
        def_object_message "{integer: x}", :add do |object|
          plambda "y" do |value|
            if value[0].id == :integer
              PObject.new(:integer, [object.params[0] + value[0].params[0]])
            elsif value[0].id == :decimal
              PObject.new(:decimal, [object.params[0] + value[0].params[0]])
            end
          end
        end
        
        def_object_message "{integer: x}", :sub do |object|
          plambda "y" do |value|
            if value[0].id == :integer
              PObject.new(:integer, [object.params[0] - value[0].params[0]])
            elsif value[0].id == :decimal
              PObject.new(:decimal, [object.params[0] - value[0].params[0]])
            end
          end
        end
        
        def_object_message "{integer: x}", :mul do |object|
          plambda "y" do |value|
            if value[0].id == :integer
              PObject.new(:integer, [object.params[0] * value[0].params[0]])
            elsif value[0].id == :decimal
              PObject.new(:decimal, [object.params[0] * value[0].params[0]])
            end
          end
        end
        
        def_object_message "{integer: x}", :div do |object|
          plambda "y" do |value|
            if value[0].id == :integer
              PObject.new(:integer, [object.params[0] / value[0].params[0]])
            elsif value[0].id == :decimal
              PObject.new(:decimal, [object.params[0] / value[0].params[0]])
            end
          end
        end
        
        def_object_message "{integer: x}", :mod do |object|
          plambda "y" do |value|
            if value[0].id == :integer
              PObject.new(:integer, [object.params[0] % value[0].params[0]])
            elsif value[0].id == :decimal
              PObject.new(:decimal, [object.params[0] % value[0].params[0]])
            end
          end
        end
        
        def_object_message "{integer: x}", :major do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] > value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: integer"
            end
          end
        end
        
        def_object_message "{integer: x}", :major_equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] >= value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: integer"
            end
          end
        end
        
        def_object_message "{integer: x}", :minor do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] < value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: integer"
            end
          end
        end
        
        def_object_message "{integer: x}", :minor_equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] <= value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: integer"
            end
          end
        end
        
        def_object_message "{integer: x}", :equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] == value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: integer"
            end
          end
        end
        
        def_object_message "{integer: x}", :diff do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
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
