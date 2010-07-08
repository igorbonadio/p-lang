module PLang
  module IO
    def IO.def_pfunctions(env)
      env.add_var(:print, IO.pprint)
    end
    
    def IO.pprint
      lamb = Proc.new do |values|
        values.each do |value|
          puts value.to_s
        end
      end
      lamb.form = [nil]
      [lamb]
    end
  end
end
