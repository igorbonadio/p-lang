module PLang
  module VM
    module PFunctions
      def add_to_interpreter_miscellaneous_functions
        def_function :exit, do
          exit
        end
      end
    end
  end
end
