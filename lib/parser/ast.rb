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
      [:call, @cid.to_sexp, @params.collect(&:to_sexp)]
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
end
