require 'helper'

class TestParser < Test::Unit::TestCase
  
  def self.get_src(filename)
    File.open(File.expand_path(File.dirname(__FILE__)) + "/p-lang/" + filename, 'r').readlines.join + "\n"
  end
  
  def self.should_parse_programs
    context "The PLangParser" do
      setup do
        @parser = PLangParser.new
      end
      
      Dir.new(File.expand_path(File.dirname(__FILE__)) + '/p-lang/ok').each do |f|
        if f[-1..-1] == 'p'
          should "parse #{f} program" do
            assert @parser.parse(TestParser::get_src("ok/" + f))
          end
        end
      end
    end
  end
  
  should_parse_programs
    
end
