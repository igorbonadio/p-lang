module PLang  
  class VM
    def initialize(ast)
      @ast = ast
    end

    def execute!
      env = PLang::Environment.new
      initialize_global_environment(env)
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
        when :object
          execute_object(expr[1], expr[2], env)
        when :object_let
          execute_object_let(expr[1], expr[2], expr[3], env)
        when :object_call
          execute_object_call(expr[1], expr[2], env)
      end
    end

    def execute_literal(type, value, env)
      case type
        when :integer, :decimal, :char, :string
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
      case id[0]
        when :id
          unless id[1] == :_
            env.add_var(id[1], execute(value, env))
          end
        when :object
          add_object_var(id, execute(value, env), env)
      end
    end
    
    def add_object_var(obj, value, env)
      if obj[1] == value.type
        obj[2].each_with_index do |param, i|
          case param[0]
            when :id
              unless param[1] == :_
                case value.type
                  when :integer, :decimal, :boolean
                    env.add_var(param[1], PObject.new(value.type, [value.params[i]]))
                  else
                    env.add_var(param[1], value.params[i])
                  end
                end
            when :object
              add_object_var(param, value.params[i], env)
            else
              unless execute(param, env) == value.params[i]
                PError.raise_error(:ObjectPatternError, "in object '#{obj[1]}'")
              end
          end
        end
      else
        PError.raise_error(:ObjectTypeError, "'#{obj[1]}' expected but was '#{value.type}'")
      end
    end
    
    def execute_lambda(params, body, where, next_lambda, env)
      lambda = []
      lambda << Proc.new do |values|
        new_env = PLang::Environment.new
        new_env.parent = env
        values.each_with_index do |value, i|
          case params[i][0]
            when :id
              unless params[i][1] == :_
                new_env.add_var(params[i][1], value)
              end
            when :object
              add_object_var(params[i], value, new_env)
          end
        end
        where.each do |w|
          execute(w, new_env)
        end
        execute(body, new_env)
      end
      form = []
      params.each do |param|
        case param[0]
          when :id
            form << nil
          when :object
            form << param
          else
            form << execute(param, env).form
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
      lamb = execute(id, env)
      lamb.each do |lambda|
        if lambda.call?(values)
          return lambda.call(values)
        end
      end
      # CallFunctionError
      str_value = "("
      values.each do |v|
        str_value += "#{v.to_s}" + ","
      end
      if str_value[-1] == ","
        str_value[-1] = ")"
      else
        str_value += ")"
      end
      if id[0] == :object_call
        id = id[2]
      end
      PError.raise_error(:CallFunctionError, "in function '#{id[1]}': no pattern matches with #{id[1]}#{str_value}")
    end

    def execute_id(id, env)
      env.get_var(id)
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
    
    def execute_object(type, params, env)
      values = []
      params.each do |param|
        values << execute(param, env)
      end
      PObject.new(type, values)
    end
    
    def execute_object_let(obj, msg, value, env)
      value[1] << obj
      env.add_object_call(obj, msg[1], execute(value, env))
    end
    
    def execute_object_call(object, id, env)
      env.get_object_call(execute(object, env), id[1])
    end
  end
end
