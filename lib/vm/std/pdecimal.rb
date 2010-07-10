module PLang
  module PDecimal
    def PDecimal.def_pfunctions(env)
      env.add_object_call([:object, :decimal, [[:id, :x]]], :abs, PDecimal.abs)
      env.add_object_call([:object, :decimal, [[:id, :x]]], :ceil, PDecimal.ceil)
      env.add_object_call([:object, :decimal, [[:id, :x]]], :floor, PDecimal.floor)
      env.add_object_call([:object, :decimal, [[:id, :x]]], :to_string, PDecimal.to_string)
    end
    
    def PDecimal.abs
      lamb = Proc.new do |values|
        PObject.new(:decimal, [values[0].params[0].abs])
      end
      lamb.form = [[:object, :decimal, [[:id, :x]]]]
      [lamb]
    end
    
    def PDecimal.ceil
      lamb = Proc.new do |values|
        PObject.new(:decimal, [values[0].params[0].ceil])
      end
      lamb.form = [[:object, :decimal, [[:id, :x]]]]
      [lamb]
    end
    
    def PDecimal.floor
      lamb = Proc.new do |values|
        PObject.new(:decimal, [values[0].params[0].floor])
      end
      lamb.form = [[:object, :decimal, [[:id, :x]]]]
      [lamb]
    end
    
    def PDecimal.to_string
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].to_s])
      end
      lamb.form = [[:object, :decimal, [[:id, :x]]]]
      [lamb]
    end
  end
end
