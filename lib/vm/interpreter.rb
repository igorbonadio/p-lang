module PLang
  module VM
    class Interpreter
      include PFunctions
      
      def initialize(ast)
        @ast = ast
      end

      def execute!
        result = nil
        env = load_basic_environment
        @ast.each do |ast|
          result = execute(ast, env)
        end
        result
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
        if ast.class == PLang::Parser::Node
          case ast.type
            when :integer, :decimal, :string, :char, :boolean
              execute_literal(ast.type, ast.value, env)
            when :object
              execute_object(ast.id, ast.params, env)
            when :list
              execute_list(ast.elements, env)
            when :if
              execute_if(ast.condition, ast.true_expr, ast.false_expr, env)
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
            when :add, :sub, :mul, :div, :equal, :diff, :major, :major_equal, :minor, :minor_equal
              execute_binop(ast.type, ast.lhs, ast.rhs, env)
            when :and, :or
              execute_binop("_#{ast.type}".to_sym, ast.lhs, ast.rhs, env)
            when :not
              execute_unop("_#{ast.type}".to_sym, ast.lhs, env)
          end
        else
          ast
        end
      end

      def execute_if(cond, true_expr, false_expr, env)
        cond = execute(cond, env)
        if cond.id == :boolean
          if cond.params[0] == :true
            execute(true_expr, env)
          else
            execute(false_expr, env)
          end
        else
          raise "TODO: if error"
        end
      end
      
      def execute_binop(type, lhs, rhs, env)
        execute_call(execute_object_message(lhs,PLang::Parser::Node.new(:id, {:value => type}), env), [rhs], env)
      end
      
      def execute_unop(type, lhs, env)
        execute_call(execute_object_message(lhs,PLang::Parser::Node.new(:id, {:value => type}), env), [], env)
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
