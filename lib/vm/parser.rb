module PLang
  module VM
    class Parser
      def initialize(src)
        @eof = Token.new(:eof)
        @lexer = Lexer.new(src)
        consume
      end

      def parse
        program
      end

      private

      def skip_breaks
        while token
          break unless token.type == :break
          consume
        end
      end

      def program
        p = []
        skip_breaks
        while token.type != :eof
          p << expr
        end
        p
      end

      def expr
        if token.type == :begin
          ast = pbegin
        elsif token.type == :list
          ast = plist
        elsif token.type == :not
          ast = pnot
        elsif ast = element
          skip_breaks
          case token.type
            when :add, :sub, :mul, :div, :mod
              ast = arithmetic(ast)
            when :equal, :diff, :major, :major_equal, :minor, :minor_equal, :and, :or
              ast = conditional(ast)
            when :let
              ast = let(ast)
          end
        end
        skip_breaks
        ast
      end

      def plambda
        pl = []
        w = []

        pl << plambda_partial
        while token.type == :comma
          consume_and_skip_breaks
          pl << plambda_partial
        end
        if token.type == :colon
          consume_and_skip_breaks
          w = where
        end
        [:lambda, pl, w]
      end

      def plambda_partial
        if token.type == :lsquare
          consume_and_skip_breaks
          params = expr_list
          if token.type == :pipe
            consume_and_skip_breaks
            body = expr
            if token.type == :rsquare
              consume
              return [params, body]
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ']'")
            end
          else
            if token.type == :rsquare
              consume
              return [[], params]
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ']'")
            end
          end
        end
      end

      def where
        if token.type == :lround
          consume_and_skip_breaks
          ll = let_list
          if token.type == :rround
            consume
            return ll
          else
            Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ')'")
          end
        end
      end

      def let_list
        ll = []
        e = element
        if token.type == :let
          e = let(e)
        else
          Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting '='")
        end
        ll << e
        while token.type == :comma
          consume_and_skip_breaks
          e = element
          if token.type == :let
            e = let(e)
          else
            Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting '='")
          end
          ll << e
        end
        ll
      end

      def pobject
        if token.type == :lcurly
          consume_and_skip_breaks
          id = token
          if id.type == :id
            consume_and_skip_breaks
            if token.type == :colon
              consume_and_skip_breaks
              ast = [:object, id.value, expr_list]
              if token.type == :rcurly
                consume_and_skip_breaks
                return ast
              else
                Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting '}'")
              end
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ':'")
            end
          else
            Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting an identifier")
          end
        end
      end

      def plist
        if token.type == :list
          consume
          if token.type == :lround
            consume
            e = expr_list
            if token.type == :rround
              consume_and_skip_breaks
              return [:list] << e
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ')'")
            end
          else
            Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting '('")
          end
        end
      end

      def pbegin
        if token.type == :begin
          consume
          if token.type == :lround
            consume
            e = expr_list
            if token.type == :rround
              consume_and_skip_breaks
              return [:begin] << e
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ')'")
            end
          else
            Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting '('")
          end
        end
      end

      def expr_list
        e = [expr]
        while token.type == :comma
          consume_and_skip_breaks
          e << expr
        end
        e
      end

      def let(ast)
        if token.type == :let
          consume_and_skip_breaks
          [:let, ast, expr]
        end
      end

      def pnot
        t = token
        case t.type
          when :not
            consume_and_skip_breaks
            [:not, expr]
        end
      end

      def conditional(ast)
        t = token
        case t.type
          when :equal, :diff, :major, :major_equal, :minor, :minor_equal, :and, :or, :not
            consume_and_skip_breaks
            conditional([t.type, ast, element])
          else
            ast
        end
      end

      def arithmetic(ast)
        t = token
        case t.type
          when :add, :sub, :mul, :div, :mod
            consume_and_skip_breaks
            arithmetic([t.type, ast, element])
          else
            ast
        end
      end

      def element
        case token.type
          when :integer, :decimal, :string, :char
            t = token
            consume
            ast = [:literal, t.type, t.value]
          when :true
            t = token
            consume
            ast = [:literal, :boolean, :true]
          when :false
            t = token
            consume
            ast = [:literal, :boolean, :false]
          when :lsquare
            ast = plambda
            if token.type == :lround
              ast = pcall(ast)
            end
          when :lcurly
            ast = pobject
          when :id
            t = token
            consume
            ast = [:id, t.value]
            if token.type == :lround
              ast = pcall(ast)
            end
          when :lround
            consume_and_skip_breaks
            e = expr
            if token.type == :rround
              consume
              ast = e
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ')'")
            end
          else
            Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting '<element>'")
        end
        skip_breaks
        if token.type == :arrow
          ast = object_message(ast)
          if token.type == :lround
            ast = pcall(ast)
          end
        end
        ast
      end

      def pcall(ast)
        consume_and_skip_breaks
        params = []
        params = expr_list unless token.type == :rround
        if token.type == :rround
          consume
          ast =  [:call, ast, params]
          if token.type == :lround
            ast = pcall(ast)
          end
          if token.type == :arrow
            ast = object_message(ast)
            if token.type == :lround
              ast = pcall(ast)
            end
          end
        else
          Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ')'")
        end
        ast
      end

      def object_message(ast)
        if token.type == :arrow
          consume_and_skip_breaks
          id = token
          if id.type == :id
            consume
            [:object_message, ast, [:id, id.value]]
          end
        end
      end

      def consume
        t = @lexer.next_token
        if t
          @token = t
        else
          @token.type = :eof
        end
      end

      def consume_and_skip_breaks
        consume
        skip_breaks
      end

      def token
        @token || @eof
      end
    end
  end
end
