module Ast
  class PStatement
    def initialize(expression)
      @expression = expression
    end

    def to_sexp
      @expression.to_sexp
    end
  end

  class PBinOp
    attr_reader :op
    attr_reader :left
    attr_reader :right

    def initialize(op, left, right)
      @op = op.to_sym
      @left = left
      @right = right
    end

    def to_sexp
      [@op, @left.to_sexp, @right.to_sexp]
    end
  end

  class PLiteral
    attr_reader :type
    attr_reader :value

    def initialize(type, value)
      @type = type.to_sym
      @value = value
    end

    def to_sexp
      [:literal, @type, @value]
    end
  end

  class PId
    attr_reader :name

    def initialize(name)
      @name = name.to_sym
    end

    def to_sexp
      [:id, @name]
    end
  end

  class PObject
    attr_reader :name

    def initialize(name, params)
      @name = name.to_sym
      @params = params
    end

    def to_sexp
      [:object, @name, @params.collect(&:to_sexp)]
    end
  end

  class PCall
    attr_reader :cid

    def initialize(cid, params)
      @cid = cid
      @params = params
    end

    def to_sexp
      @cid = @cid.to_sexp
      if @cid == [:id, :if]
        @params = @params.collect(&:to_sexp)
        if @params.size == 3
          [:if, @params[0], @params[1], @params[2]]
        else
          raise "'if' error"
        end
      else
        [:call, @cid, @params.collect(&:to_sexp)]
      end
    end
  end

  class PLet
    attr_reader :var
    attr_reader :val

    def initialize(var, val)
      @var = var
      @val = val
    end

    def to_sexp
      [:let, @var.to_sexp, @val.to_sexp]
    end
  end

  class PLambda
    attr_reader :params
    attr_reader :expr
    attr_reader :where

    def initialize(params, expr, where)
      @params = params
      @expr = expr
      @where = where
    end

    def to_sexp
      [:lambda, @params.collect(&:to_sexp), @expr.to_sexp, @where.collect(&:to_sexp)]
    end
  end

  class PObjectCall
    attr_reader :obj
    attr_reader :msg

    def initialize(obj, msg)
      @obj = obj
      @msg = msg
    end

    def to_sexp
      [:object_call, @obj.to_sexp, @msg.to_sexp]
    end
  end

  class PObjectLet
    attr_reader :obj
    attr_reader :id
    attr_reader :value

    def initialize(obj, id, value)
      @obj = obj
      @id = id
      @value = value
    end

    def to_sexp
      [:object_let, @obj.to_sexp, @id.to_sexp, @value.to_sexp]
    end
  end
end
