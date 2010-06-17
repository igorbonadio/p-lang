require 'helper'

class TestParser < Test::Unit::TestCase
  
  #def self.get_src(filename)
  #  File.open(File.expand_path(File.dirname(__FILE__)) + "/" + filename, 'r').readlines
  #end

  EXPRESSIONS = File.readlines(File.join(File.dirname(__FILE__), "test_parser_ok.txt"))
  BUILT_EXPRESSIONS = File.readlines(File.join(File.dirname(__FILE__), "test_parser_build.txt"))
  
  context "The PLangParser" do
    setup do
      @parser = PLangParser.new
    end
    
    EXPRESSIONS.each_with_index do |expr, i|
      should "parse the expression ##{i}" do
        assert @parser.parse expr
      end
    end

    EXPRESSIONS.each_with_index do |expr, i|
      if i < 26
        should "build the expression ##{i}" do
          assert_equal eval(BUILT_EXPRESSIONS[i]), @parser.parse(expr).build.collect(&:to_sexp)
        end
      end
    end
  end
  
end
