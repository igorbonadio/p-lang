module PLang

  module NStatements
    def build
      elements.collect { |element| Ast::Statement.new(element.statement.build) }
    end
  end

  module NBinOp
    def build
      Ast::BinOp.new(op.text_value, expr.build, statement.build)
    end
  end

  module NInteger
    def build
      Ast::Literal.new(:integer, text_value.to_i)
    end
  end

  module NDecimal
    def build
      Ast::Literal.new(:decimal, text_value.to_f)
    end
  end

  module NParemExpr
    def build
      statement.build
    end
  end

end
