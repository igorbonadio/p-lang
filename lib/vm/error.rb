module PLang
  module VM
    class Error
      def Error.syntax_error(line, src, i, msg)
        error = "#{line}:sintax error: #{msg}\n#{Error.show_error(src, i)}"
        raise error
      end

      private

      def Error.show_error(src, i)
        _src = src[0,i]
        src[i,src.length].each_byte do |c|
          break if c.chr == "\n"
          _src += c.chr
        end
        pos = _src.length - i
        __src = ""
        _src.reverse.each_byte do |c|
          break if c.chr == "\n"
          __src += c.chr
        end
        __src = __src.reverse
        __src += "\n"
        (__src.length - pos -1).times do
          __src += " "
        end
        __src += "^"
      end
    end
  end
end
