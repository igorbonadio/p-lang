module PLang
  module VM
    module PFunctions
      def add_to_interpreter_decimal_functions
        
        object_message "{decimal: x}", :add do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:decimal, [object.params[0] + value[0].params[0]])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :sub do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:decimal, [object.params[0] - value[0].params[0]])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :mul do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:decimal, [object.params[0] * value[0].params[0]])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :div do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:decimal, [object.params[0] / value[0].params[0]])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :mod do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:decimal, [object.params[0] % value[0].params[0]])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :major do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] > value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :major_equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] >= value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :minor do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] < value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :minor_equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] <= value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :equal do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] == value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: decimal"
            end
          end
        end
        
        object_message "{decimal: x}", :diff do |object|
          plambda "y" do |value|
            case value[0].id
              when :integer, :decimal
                PObject.new(:boolean, [(object.params[0] != value[0].params[0]).to_s.to_sym])
              else
                raise "TODO: decimal"
            end
          end
        end
        
      end
    end
  end
end