module PLang
  module VM
    class Interpreter
      def initialize(ast)
        @ast = ast
      end

      def execute!
        env = Environment.new
        @ast.each do |ast|
          p execute(ast, env)
        end
      end

      private

      def execute(ast, env)
        case ast.type
          when :integer, :decimal, :string, :char, :boolean
            execute_literal(ast.type, ast.value, env)
          when :object
            execute_object(ast.id, ast.params, env)
          when :list
            execute_list(ast.elements, env)
          when :lambda
            execute_lambda(ast.params, ast.body, ast.where, ast.next_lambda, env)
          when :let
            execute_let(ast.lhs, ast.rhs, env)
          when :id
            execute_id(ast.value, env)
          when :begin
            execute_begin(ast.expressions, env)
        end
      end

      def execute_literal(type, value, env)
        PObject.new(type, [value])
      end

      def execute_object(id, params, env)
        object_params = []
        params.each do |param|
          object_params << execute(param, env)
        end
        case id.value
          when :integer, :decimal, :string, :char, :boolean
            if object_params.length == 1 and object_params[0].id == id.value
              PObject.new(id.value, object_params[0].params)
            end
          else
            PObject.new(id.value, object_params)
        end
      end

      def execute_lambda(params, body, where, next_lambda, env)
        lambda = []
        lambda << Proc.new do |values|
          #TODO: lambda!
        end
        if next_lambda
          lambda |= execute(next_lambda, env).params
        end
        PObject.new(:lambda, lambda)
      end

      def execute_let(lhs, rhs, env)
        env.set_var(lhs.value, execute(rhs, env))
      end

      def execute_id(id, env)
        env.get_var(id)
      end

      def execute_begin(expressions, env)
        ret = nil
        expressions.each do |expr|
          ret = execute(expr, env)
        end
        ret
      end

      def execute_list(elements, env)
        e = []
        elements.each do |element|
          e << execute(element, env)
        end
        PObject.new(:list, e)
      end
    end
  end
end
