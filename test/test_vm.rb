require 'helper'

class TestVM < Test::Unit::TestCase
  
  PROGRAMS = File.readlines(File.join(File.dirname(__FILE__), "test_vm"))
  RESULT = File.readlines(File.join(File.dirname(__FILE__), "test_vm_result"))
  
  context "The VM" do
    
    PROGRAMS.each_with_index do |program, i|
      vm = PLang::VM::Interpreter.new(PLang::Parser::SyntaxAnalyser.new(program).parse)
      should "interp the expression ##{i}" do
        assert_equal vm.execute!.params[0], eval(RESULT[i])
      end
    end
  
  end
  
end
