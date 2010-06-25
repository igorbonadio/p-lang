module PLang

  module NStatements
    def build
      elements.collect { |element| PLang::Ast::PStatement.new(element.statement.build) }
    end
  end

  module NCStatementList
    def build
      stm = statement_list.build
      unless stm.class == Array
        stm = [stm]
      end
      [statement.build] + stm
    end
  end

  module NBinOp
    def build
      PLang::Ast::PBinOp.new(op.text_value, expr.build, statement.build)
    end
  end

  module NUnOp
    def build
      PLang::Ast::PUnOp.new(:not, statement.build)
    end
  end

  module NInteger
    def build
      PLang::Ast::PLiteral.new(:integer, text_value.to_i)
    end
  end

  module NDecimal
    def build
      PLang::Ast::PLiteral.new(:decimal, text_value.to_f)
    end
  end

  module NString
    def build
      PLang::Ast::PLiteral.new(:string, str.text_value)
    end
  end

  module NChar
    def build
      PLang::Ast::PLiteral.new(:char, c.text_value)
    end
  end

  module NId
    def build
      PLang::Ast::PId.new(text_value)
    end
  end

  module NObject
    def build
      if obj_list.respond_to?(:build)
        params = obj_list.build
        unless params.class == Array
          params = [params]
        end
        PLang::Ast::PObject.new(id.text_value, params)
      else
        PLang::Ast::PObject.new(id.text_value, [])
      end
    end
  end

  module NObjectList
    def build
      statement_list.build
    end
  end

  module NParemExpr
    def build
      statement.build
    end
  end

  module NCall
    def build
      params = []
      if cparams.respond_to?(:build)
        params = cparams.build
        unless params.class == Array
          params = [params]
        end
      end
      PLang::Ast::PCall.new(cid.build, params)
    end
  end

  module NVarLet
    def build
      PLang::Ast::PLet.new(var.build, statement.build)
    end
  end

  module NLambda
    def build
      @where = []
      if where.respond_to?(:build)
        @where = where.build
      end
      @params = []
      if params.respond_to?(:build)
        @params = params.build
      end
      PLang::Ast::PLambda.new(@params, statement.build, @where)
    end
  end

  module NCLambda
    def build
      nlambda = lamb.build
      nlambda.next_lambda = lambda.build.to_sexp
      nlambda
    end
  end

  module NWhere
    def build
      w = where_params.build
      if w.class == Array
        w
      else
        [w]
      end
    end
  end

  module NCWhereParams
    def build
      w = where_params.build
      unless w.class == Array
        w = [w]
      end
      [let.build] + w
    end
  end

  module NLambdaParams
    def build
      params = lambda_params_list.build
      if params.class == Array
        params
      else
        [params]
      end
    end
  end

  module NCLambdaParamsList
    def build
      params = lambda_params_list.build
      unless params.class == Array
        params = [params]
      end
      [form.build] + params
    end
  end

  module NObjectForm
    def build
      if obj_form_list.respond_to?(:build)
        PLang::Ast::PObject.new(id.text_value, obj_form_list.build)
      else
        PLang::Ast::PObject.new(id.text_value, [])
      end
    end
  end

  module NObjectGet
    def build
      PLang::Ast::PObjectCall.new(expr.build, id.build)
    end
  end

  module NObjectMsg
    def build
      params = []
      if statement_list.respond_to?(:build)
        params = statement_list.build
        unless params.class == Array
          params = [params]
        end
      end
      PLang::Ast::PCall.new(PLang::Ast::PObjectCall.new(expr.build, id.build), [expr.build] | params)
    end
  end

  module NObjectLet
    def build
      PLang::Ast::PObjectLet.new(object_form.build, var.build, statement.build)
    end
  end

  module NBoolean
    def build
      PLang::Ast::PLiteral.new(:boolean, text_value.to_sym)
    end
  end

end

