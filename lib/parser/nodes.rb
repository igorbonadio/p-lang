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

  module NString
    def build
      Ast::PLiteral.new(:string, str.text_value)
    end
  end

  module NChar
    def build
      Ast::PLiteral.new(:char, c.text_value)
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
      obj_list = [statement_list.statement.build]
      if statement_list.stm_list.elements.respond_to?(:collect) 
        obj_list |= statement_list.stm_list.elements.collect { |element| element.statement.build }
      end
      obj_list
    end
  end

  module NParemExpr
    def build
      statement.build
    end
  end

  module NCall
    def build
      params = [cparams.statement.build]
      if cparams.stm_list.elements.respond_to?(:collect)
        params |= cparams.stm_list.elements.collect { |element| element.statement.build }
      end
      Ast::PCall.new(cid.build, params)
    end
  end

  module NVarLet
    def build
      Ast::PLet.new(var.build, statement.build)
    end
  end

end

