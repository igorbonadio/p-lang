module PLang

  module NStatements
    def build
      elements.collect { |element| Ast::PStatement.new(element.statement.build) }
    end
  end

  module NBinOp
    def build
      Ast::PBinOp.new(op.text_value, expr.build, statement.build)
    end
  end

  module NInteger
    def build
      Ast::PLiteral.new(:integer, text_value.to_i)
    end
  end

  module NDecimal
    def build
      Ast::PLiteral.new(:decimal, text_value.to_f)
    end
  end

  module NId
    def build
      Ast::PId.new(text_value)
    end
  end

  module NObject
    def build
      if obj_list.respond_to?(:build)
        Ast::PObject.new(id.text_value, obj_list.build)
      else
        Ast::PObject.new(id.text_value, [])
      end
    end
  end

  module NObjectList
    def build
      [statement_list.statement.build] | statement_list.stm_list.elements.collect { |element| element.statement.build }
    end
  end

  module NParemExpr
    def build
      statement.build
    end
  end

end
