module PLang
  module VM
    module PFunctions
      def add_to_interpreter_io_functions
        
        var :print, (plambda "x" do |params|
          puts params[0].to_s
        end)

        var :read, (plambda do
          PObject.new(:string, [STDIN.gets])
        end)
      end
    end
  end
end
