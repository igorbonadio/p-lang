ROOT_PATH = File.expand_path(File.dirname(__FILE__))

require File.join(ROOT_PATH, '/_vm/lexer')
require File.join(ROOT_PATH, '/_vm/error')
require File.join(ROOT_PATH, '/_vm/token')

lexer = PLang::VM::Lexer.new("
aaaaa = 1
2.3
\"aaaa\"
1
!=
'a'
#'aaa'
#\"aaaa
><===<==!
")

begin
  while token = lexer.next_token
    puts token
  end
rescue Exception => e
  puts "fib.p:#{e.message}"
end

