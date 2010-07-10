module PLang
  module PInteger
    def PInteger.def_pfunctions(env)
      env.add_object_call([:object, :integer, [[:id, :x]]], :abs, PInteger.abs)
      env.add_object_call([:object, :integer, [[:id, :x]]], :to_decimal, PInteger.to_decimal)
      env.add_object_call([:object, :integer, [[:id, :x]]], :to_string, PInteger.to_string)
      env.add_object_call([:object, :integer, [[:id, :x]]], :next, PInteger.next)
    end
    
    def PInteger.abs
      lamb = Proc.new do |values|
        PObject.new(:integer, [values[0].params[0].abs])
      end
      lamb.form = [[:object, :integer, [[:id, :x]]]]
      [lamb]
    end
    
    def PInteger.next
      lamb = Proc.new do |values|
        PObject.new(:integer, [values[0].params[0].next])
      end
      lamb.form = [[:object, :integer, [[:id, :x]]]]
      [lamb]
    end
    
    def PInteger.to_decimal
      lamb = Proc.new do |values|
        PObject.new(:decimal, [values[0].params[0].to_f])
      end
      lamb.form = [[:object, :integer, [[:id, :x]]]]
      [lamb]
    end
    
    def PInteger.to_string
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].to_s])
      end
      lamb.form = [[:object, :integer, [[:id, :x]]]]
      [lamb]
    end
  end
end
