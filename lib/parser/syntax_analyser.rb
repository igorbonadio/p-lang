module PLang
  module Parser
    class SyntaxAnalyser
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

        if token.type == :lsquare
          consume_and_skip_breaks
          params = expr_list
          if token.type == :pipe
            consume_and_skip_breaks
            body = expr
            if token.type == :rsquare
              consume
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ']'")
            end
          else
            if token.type == :rsquare
              if params.length == 1
                body = params[0]
                params = []
              else
                Error.syntax_error(token.line, token.src, token.i, "invalid function body")
              end
              consume
            else
              Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting ']'")
            end
          end
        end        
        if token.type == :colon
          consume_and_skip_breaks
          w = where
        else
          w = []
        end
        if token.type == :semicolon
          consume_and_skip_breaks
          return Node.new(:lambda, {:params => params, :body => body, :where => w, :next_lambda => plambda})
        else
          return Node.new(:lambda, {:params => params, :body => body, :where => w, :next_lambda => nil})
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
              ast = Node.new(:object, {:id => Node.new(:id, {:value => id.value}), :params => expr_list})
              if token.type == :rcurly
                consume_and_skip_breaks
                return ast
              else
                Error.syntax_error(token.line, token.src, token.i, "unexpected '#{token.value}', expecting '}'")
              end
            elsif token.type == :rcurly
              consume_and_skip_breaks
              ast = Node.new(:object, {:id => Node.new(:id, {:value => id.value}), :params => []})
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
            consume_and_skip_breaks
            e = expr_list
            if token.type == :rround
              consume_and_skip_breaks
              return Node.new(:list, {:elements => e})
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
            consume_and_skip_breaks
            e = expr_list
            if token.type == :rround
              consume_and_skip_breaks
              return Node.new(:begin, {:expressions => e})
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
          Node.new(:let, {:lhs => ast, :rhs => expr})
        end
      end

      def pnot
        t = token
        case t.type
          when :not
            consume_and_skip_breaks
            Node.new(:not, {:lhs => expr})
        end
      end

      def conditional(ast)
        t = token
        case t.type
          when :equal, :diff, :major, :major_equal, :minor, :minor_equal, :and, :or, :not
            consume_and_skip_breaks
            conditional(Node.new(t.type, {:lhs => ast, :rhs => element}))
          else
            ast
        end
      end

      def arithmetic(ast)
        t = token
        case t.type
          when :add, :sub, :mul, :div, :mod
            consume_and_skip_breaks
            arithmetic(Node.new(t.type, {:lhs => ast, :rhs => element}))
          else
            ast
        end
      end

      def element
        case token.type
          when :integer, :decimal, :string, :char
            t = token
            consume
            ast = Node.new(t.type, {:value => t.value})
          when :true
            t = token
            consume
            ast = Node.new(:boolean, {:value => :true})
          when :false
            t = token
            consume
            ast = Node.new(:boolean, {:value => :false})
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
            ast = Node.new(:id, {:value => t.value})
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
          ast =  Node.new(:call, {:lambda => ast, :params => params})
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
            Node.new(:object_message, {:object => ast, :message => Node.new(:id, {:value=>id.value})})
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
