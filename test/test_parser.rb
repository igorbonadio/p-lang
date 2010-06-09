require 'helper'

class TestParser < Test::Unit::TestCase
  
  def self.get_src(filename)
    File.open(File.expand_path(File.dirname(__FILE__)) + "/" + filename, 'r').readlines
  end
  
  context "The PLangParser" do
    setup do
      @parser = PLangParser.new
    end
    
    i = 0
    TestParser::get_src('test_parser_ok.txt').each do |expr|
      i = i + 1
      should "parse the expression ##{i}" do
        assert @parser.parse expr
      end
    end
  end
  
end
