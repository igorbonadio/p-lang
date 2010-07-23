require 'helper'

class TestLexer < Test::Unit::TestCase
  
  EXPRESSIONS = File.readlines(File.join(File.dirname(__FILE__), "test_lexer"))
  TOKENS = File.readlines(File.join(File.dirname(__FILE__), "test_lexer_tokens"))
  
  context "The Lexer" do
    
    EXPRESSIONS.each_with_index do |expr, i|
      lexer = PLang::VM::Lexer.new(EXPRESSIONS[i])
      should "tokenize the expression ##{i}" do
        assert_equal lexer.next_token.type, eval(TOKENS[i])
      end
    end
  
  end
  
end
