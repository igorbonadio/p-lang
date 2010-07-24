require 'helper'

class TestParser < Test::Unit::TestCase
  
  EXPRESSIONS = File.readlines(File.join(File.dirname(__FILE__), "test_parser"))
  BUILD = File.readlines(File.join(File.dirname(__FILE__), "test_parser_build"))
  
  context "The Parser" do
    
    EXPRESSIONS.each_with_index do |expr, i|
      parser = PLang::Parser::SyntaxAnalyser.new(EXPRESSIONS[i])
      should "parse the expression ##{i}" do
        assert_equal parser.parse, eval(BUILD[i])
      end
    end
  
  end
  
end
