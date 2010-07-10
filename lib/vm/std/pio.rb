module PLang
  module PIO
    def PIO.def_pfunctions(env)
      env.add_var(:print, PIO.pprint)
    end
    
    def PIO.pprint
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