module PLang
  class VM
    def initialize(ast)
      @ast = ast
    end

    def execute!
      env = PLang::Environment.new
      @ast.each do |expr|
        @ret = execute(expr, env)
      end
      @ret
    end

    def execute(expr, env)
      case expr[0]
        when :literal
          execute_literal(expr[1], expr[2], env)
        when :let
          execute_let(expr[1], expr[2], env)
        when :lambda
          execute_lambda(expr[1], expr[2], expr[3], expr[4], env)
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
        when :integer, :decimal
          PObject.new(type, [value])
        when :boolean
          if value == :true
            PObject.new(:boolean, [true])
          elsif value == :false
            PObject.new(:boolean, [false])
          end
      end
    end

    def execute_let(id, value, env)
      env.add(id[1], execute(value, env))
    end

    def execute_lambda(params, body, where, next_lambda, env)
      lambda = []
      lambda << Proc.new do |values|
        new_env = PLang::Environment.new
        new_env.parent = env
        values.each_with_index do |value, i|
          if params[i][0] == :id
            new_env.add(params[i][1], value)
          end
        end
        where.each do |w|
          execute(w, new_env)
        end
        execute(body, new_env)
      end
      form = []
      params.each do |param|
        unless param[0] == :id
          form << execute(param, env)
        else
          form << nil
        end
      end
      lambda[0].form = form
      if next_lambda
        lambda |= execute(next_lambda, env)
      end
      lambda
    end

    def execute_call(id, params, env)
      values = []
      params.each do |param|
        values << execute(param, env)
      end
      execute(id, env).each do |lambda|
        if lambda.call?(values)
          return lambda.call(values)
        end
      end
    end

    def execute_id(id, env)
      env.get(id)
    end

    def execute_binop(op, lhs, rhs, env)
      lhs = execute(lhs, env)
      rhs = execute(rhs, env)
      result = lhs.params[0].send(op,rhs.params[0])
      if result.class == Fixnum or result.class == Bignum
        return PObject.new(:integer, [result])
      elsif result.class == Float
        return PObject.new(:decimal, [result])
      elsif result.class == TrueClass or result.class == FalseClass
        return PObject.new(:boolean, [result])
      end
    end

    def execute_and(lhs, rhs, env)
      lhs = execute(lhs, env) 
      rhs = execute(rhs, env)
      PObject.new(:boolean, [(lhs.params[0] and rhs.params[0])])
    end

    def execute_or(lhs, rhs, env)
      lhs = execute(lhs, env) 
      rhs = execute(rhs, env)
      PObject.new(:boolean, [(lhs.params[0] or rhs.params[0])])
    end

    def execute_if(cond, t, f, env)
      cond = execute(cond, env)
      if cond.params[0]
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
