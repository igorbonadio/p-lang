module PLang
  class VM
    def initialize(ast)
      @ast = ast
    end

    def execute!
      env = PLang::Environment.new
      @ast.each do |expr|
        p expr
        p execute(expr, env)
      end
    end

    def execute(expr, env)
      case expr[0]
        when :literal
          execute_literal(expr[1], expr[2], env)
        when :let
          execute_let(expr[1], expr[2], env)
        when :lambda
          execute_lambda(expr[1], expr[2], expr[3], env)
        when :call
          execute_call(expr[1], expr[2], env)
        when :id
          execute_id(expr[1], env)
        when :+, :-, :*, :/, :%, :>, :<, :>=, :<=, :==
          execute_binop(expr[0], expr[1], expr[2], env)
        when :and
          execute_and(expr[1], expr[2], env)
        when :or
          execute_or(expr[1], expr[2], env)
        when :if
          execute_if(expr[1], expr[2], expr[3], env)
        when :begin
          execute_begin(expr[1], env)
      end
    end

    def execute_literal(type, value, env)
      case type
        when :integer
          value
        when :decimal
          value
        when :boolean
          if value == :true
            true
          elsif value == :false
            false
          end
      end
    end

    def execute_let(id, value, env)
      env.add(id[1], execute(value, env))
    end

    def execute_lambda(params, body, where, env)
      Proc.new do |values|
        new_env = PLang::Environment.new
        new_env.parent = env
        values.each_with_index do |value, i|
          new_env.add(params[i][1], value)
        end
        where.each do |w|
          execute(w, new_env)
        end
        execute(body, new_env)
      end
    end

    def execute_call(id, params, env)
      values = []
      params.each do |param|
        values << execute(param, env)
      end
      execute(id, env).call(values)
    end

    def execute_id(id, env)
      env.get(id)
    end

    def execute_binop(op, lhs, rhs, env)
      execute(lhs, env).send(op,execute(rhs, env))
    end

    def execute_and(lhs, rhs, env)
      execute(lhs, env) and execute(rhs, env)
    end

    def execute_or(lhs, rhs, env)
      execute(lhs, env) or execute(rhs, env)
    end

    def execute_if(cond, t, f, env)
      if execute(cond, env)
        execute(t, env)
      else
        execute(f, env)
      end
    end

    def execute_begin(exprs, env)
      ret = nil
      exprs.each do |expr|
        ret = execute(expr, env)
      end
      ret
    end
  end
end
