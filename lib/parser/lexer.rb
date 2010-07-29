module PLang
  module Parser
    class Lexer
      def initialize(src)
        @line = 1
        @src = src+"\n"
        process()
      end

      def next_token
        @fib.resume
      end

      private

      def process()
        @i = 0
        @fib = Fiber.new do
          while @i < @src.length
            case @src[@i]
              when 'a'..'z', 'A'..'Z', '_'
                @i = identifier
              when '0'..'9'
                @i = number
              when "'"
                @i = char
              when '"'
                @i = string
              when '['
                 send_token(:lsquare, '[')
                 @i += 1
              when ']'
                 send_token(:rsquare, ']')
                 @i += 1
              when '('
                 send_token(:lround, '(')
                @i += 1
              when ')'
                 send_token(:rround, ')')
                @i += 1
              when '{'
                 send_token(:lcurly, '{')
                @i += 1
              when '}'
                 send_token(:rcurly, '}')
                @i += 1
              when ','
                 send_token(:comma, ',')
                @i += 1
              when ';'
                 send_token(:semicolon, ';')
                @i += 1
              when '|'
                 send_token(:pipe, '|')
                @i += 1
              when ':'
                 send_token(:colon, ':')
                @i += 1
              when '-'
                @i = sub
              when '+'
                 send_token(:add, '+')
                @i += 1
              when '*'
                 send_token(:mul, '*')
                @i += 1
              when '/'
                 send_token(:div, '/')
                @i += 1
              when '%'
                 send_token(:mod, '%')
                @i += 1
              when '='
                @i = equal
              when '!'
                @i = diff
              when '>'
                @i = major
              when '<'
                @i = minor
              when '#'
                @i = comment
              when "\t", "\s"
                @i += 1
              when "\n"
                send_token(:break, "\\n")
                @line += 1
                @i += 1
              when "\r"
                send_token(:break, "\\r")
                @line += 1
                @i += 1
              else
                Error.syntax_error(@line, @src, @i, "unknown token '#{@src[@i]}'")
            end
          end
        end
      end

      def send_token(type, value)
        token = Token.new(type)
        token.value = value
        token.line = @line
        token.i = @i
        token.src = @src
        Fiber.yield token
      end

      def identifier
        token = ""
        while ('a'..'z') === @src[@i] or ('A'..'Z') === @src or ('0'..'9') === @src[@i] or @src[@i] == '_'
          token += @src[@i]
          @i += 1
        end
        token = token.to_sym
        case token
          when :and, :or, :not, :true, :false, :nil, :begin, :if
             send_token(token, token)
          else
             send_token(:id, token)
        end
        @i
      end

      def number
        token = ""
        type = :integer
        while ('0'..'9') === @src[@i]
          token += @src[@i]
          @i += 1
        end
        if @src[@i] == '.'
          token += "."
          type = :decimal
          @i+=1
          ok = false
          while ('0'..'9') === @src[@i]
            token += @src[@i]
            @i += 1
            ok = true
          end
          if not ok
            Error.syntax_error(@line, @src, @i, "invalid decimal number")
          end
        end
        if type == :decimal
           send_token(:decimal, token.to_f)
        else
           send_token(:integer, token.to_i)
        end
        @i
      end

      def char
        unless @src[@i+2] == "'"
          if @src[@i+1] == "("
            send_token(:list, :list)
            @i+1
          else
            Error.syntax_error(@line, @src, @i, "unclosed character literal")
          end
        else
          send_token(:char, @src[@i+1])
          @i+3
        end
      end

      def string
        token = ""
        @i += 1
        while @src[@i] and @src[@i] != '"'
          token += @src[@i]
          @i += 1
        end
        if @src[@i]
          send_token(:string, token)
        else
          Error.syntax_error(@line, @src, @i - token.length - 1, "unclused string literal")
        end
        @i+1
      end

      def sub
        if @src[@i+1] == '>'
           send_token(:arrow, '->')
          @i += 2
        else
           send_token(:sub, '-')
          @i += 1
        end
        @i
      end

      def equal
        if @src[@i+1] == '='
           send_token(:equal, '==')
          @i += 2
        else
           send_token(:let, '=')
          @i += 1
        end
        @i
      end

      def diff
        if @src[@i+1] == '='
           send_token(:diff, '!=')
          @i += 2
        else
          Error.syntax_error(@line, @src, @i, "unexpected '!#{@src[@i+1]}', expecting '!='")
        end
        @i
      end

      def major
        if @src[@i+1] == '='
           send_token(:major_equal, '>=')
          @i += 2
        else
           send_token(:major, '>')
          @i += 1
        end
        @i
      end

      def minor
        if @src[@i+1] == '='
           send_token(:minor_equal, '<=')
          @i += 2
        else
           send_token(:minor, '<')
          @i += 1
        end
        @i
      end

      def comment
        while @src[@i] != "\n" and @src[@i] != "\r"
          @i += 1
        end
        @i
      end
    end
  end
end
