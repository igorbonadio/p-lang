module PLang
  module VM
    class Interpreter
      def initialize(ast)
        @ast = ast
      end

      def execute!
        env = load_basic_environment
        @ast.each do |ast|
          p execute(ast, env)
        end
      end

      private
      
      def load_basic_environment
        @env = Environment.new
        libraries = methods.grep /^add_to_interpreter/
        libraries.each do |library|
          send(library)
        end
        @env
      end

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
          when :call
            execute_call(ast.lambda, ast.params, env)
          when :object_message
            execute_object_message(ast.object, ast.message, env)
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
        lambda << PLambda.new do |values|
          new_env = Environment.new
          new_env.parent = env
          values.each_with_index do |value, i|
            case params[i].type
              when :id
                new_env.set_var(params[i].value, value)
              when :object
                new_env.set_object_var(params[i], value)
            end
          end
          where.each do |w|
            execute(w, new_env)
          end
          execute(body, new_env)
        end
        params.each do |param|
          case param.type
            when :id
              lambda[0].form <<  nil
            else
              lambda[0].form << param
          end
        end
        if next_lambda
          lambda |= execute(next_lambda, env).params
        end
        PObject.new(:lambda, lambda)
      end
      
      def execute_call(lambda, params, env)
        values = []
        params.each do |param|
          values << execute(param, env)
        end
        lambda = execute(lambda, env)
        lambda.params.each do |lamb|
          return lamb.call(values) if lamb.call?(values)
        end
        raise "TODO: call error"
      end

      def execute_let(lhs, rhs, env)
        case lhs.type
          when :id
            env.set_var(lhs.value, execute(rhs, env))
          when :object
            env.set_object_var(lhs, execute(rhs, env))
          when :object_message
            params = [lhs.object, PLang::Parser::Node.new(:object, {:id => PLang::Parser::Node.new(:id, {:value => lhs.message.value}), :params => []})]
            lamb = execute_lambda(params, rhs, [], nil, env)
            begin
              env.set_var(:get_object_message, lamb)
            rescue
              env.add_lambda(:get_object_message, lamb)
            end
        end
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
        element = elements.delete_at(0)
        if element
          PObject.new(:list, [execute(element, env), execute_list(elements, env)])
        else
          PObject.new(:empty, [])
        end
      end
      
      def execute_object_message(object, message, env)
        get_object_message = PLang::Parser::Node.new(:id, {:value => :get_object_message})
        message = PLang::Parser::Node.new(:object, {:id => PLang::Parser::Node.new(:id, {:value => message.value}), :params => []})
        execute_call(get_object_message, [object, message], env)
      end
    end
  end
end
