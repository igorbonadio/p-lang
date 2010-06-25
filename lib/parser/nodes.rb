module PLang

  module NStatements
    def build
      elements.collect { |element| PLang::Ast::PStatement.new(element.statement.build) }
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
        PLang::Ast::PObject.new(id.text_value, obj_list.build)
      else
        PLang::Ast::PObject.new(id.text_value, [])
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
      params = []
      if cparams.respond_to?(:statement)
        params = [cparams.statement.build]
        if cparams.stm_list.elements.respond_to?(:collect)
          params |= cparams.stm_list.elements.collect { |element| element.statement.build }
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
      params = [where_params.let.build]
      if where_params.whr_params.elements.respond_to?(:collect)
        params |= where_params.whr_params.elements.collect { |element| element.let.build }
      end
      params
    end
  end

  module NLambdaParams
    def build
      params = [lambda_params_list.form.build]
      if lambda_params_list.lmbd_params_list.elements.respond_to?(:collect)
        params |= lambda_params_list.lmbd_params_list.elements.collect { |element| element.form.build }
      end
      params
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
      if statement_list.respond_to?(:statement)
        params = [statement_list.statement.build]
        if statement_list.stm_list.elements.respond_to?(:collect) 
          params |= statement_list.stm_list.elements.collect { |element| element.statement.build }
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

