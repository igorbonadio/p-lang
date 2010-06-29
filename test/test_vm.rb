require 'helper'

class TestParser < Test::Unit::TestCase
  
  PROGRAMS = File.readlines(File.join(File.dirname(__FILE__), "test_vm_programs.txt"))
  RESULTS = File.readlines(File.join(File.dirname(__FILE__), "test_vm_results.txt"))
  
  context "The VM" do
    setup do
      @parser = PLangParser.new
    end

    PROGRAMS.each_with_index do |program, i|
      should "interp the program ##{i}" do
        ast = @parser.parse(program)
        vm = PLang::VM.new(ast.build.collect(&:to_sexp))
        assert_equal eval(RESULTS[i]), vm.execute!.params[0]
      end
    end
  end
  
end
