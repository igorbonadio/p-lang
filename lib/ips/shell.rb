module PLang
  module IPS # = Interactive P Shell
    class Shell
      def initialize
        @expr_c = ""
        @interpreter = PLang::VM::Interpreter.new(nil)
        @env = @interpreter.send(:load_basic_environment)
      end

      def start
        while true
          begin
            execute(read)
          rescue Exception => e
            if e.class == SystemExit
              raise e
            else
              puts "ips:#{e}"
            end
          end
        end
      end

      def execute(expr)
        expr = @expr_c + expr
        sa = PLang::Parser::SyntaxAnalyser.new(expr)
        begin
          ast = sa.parse
          result = nil
          ast.each do |a|
            result = @interpreter.send(:execute, a, @env)
          end
          @expr_c = ""
          show(result)
        rescue Exception => e
          if e.message =~ /sintax error: unexpected '\\n'/
            @expr_c = expr
          else
            @expr_c = ""
            raise e
          end
        end
      end

      def show(out)
        puts " => #{out.to_s}"
      end

      def read
        if @expr_c == ""
          print "p-lang > "
        else
          print "...... > "
        end
        gets
      end
    end
  end
end
