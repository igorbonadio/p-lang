module PLang
  module VM
    module PFunctions

      def def_function(id, *params)
        def_var(id, (plambda(*params) do |values|
          yield(values)
        end))
      end

      def def_object_message(object, message)
        lamb = plambda(object, "{#{message.to_s}}") do |values|
          yield(values[0], values[1])
        end
        begin
          @env.set_var(:get_object_message, lamb)
        rescue
          @env.add_lambda(:get_object_message, lamb)
        end
      end
      
      def def_var(id, value)
        @env.set_var(id.to_sym, value)
      end      

      def plambda(*params)
        lamb = PLambda.new do |values|
          yield(values)
        end
        
        obj_params = []
        params.each do |param|
          param = object(param)
          case param.type
            when :id
              lamb.form <<  nil
            else
              lamb.form << param
          end
          obj_params << param
        end
                
        PObject.new(:lambda, [lamb, PObject.new(:empty, [])])
      end
      
      def object(expr)
        PLang::Parser::SyntaxAnalyser.new(expr).parse[0]
      end
      
    end
  end
end
