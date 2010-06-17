module Ast
  class Statement
    def initialize(expression)
      @expression = expression
    end

    def to_sexp
      @expression.to_sexp
    end
  end

  class BinOp
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

  class Literal
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

  class Id
    attr_reader :name

    def initialize(name)
      @name = name.to_sym
    end

    def to_sexp
      [:id, @name]
    end
  end
end
