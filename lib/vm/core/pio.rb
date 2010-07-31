module PLang
  module VM
    module PFunctions
      def add_to_interpreter_io_functions
        
        def_function :print, "x" do |params|
          puts params[0].to_s
        end

        def_function :read, do
          PObject.new(:string, [STDIN.gets])
        end
      end
    end
  end
end
