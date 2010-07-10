module PLang
  module PString
    def PString.def_pfunctions(env)
      env.add_object_call([:object, :string, [[:id, :x]]], :append, PString.append)
      env.add_object_call([:object, :string, [[:id, :x]]], :equal, PString.equal)
      env.add_object_call([:object, :string, [[:id, :x]]], :at, PString.at)
      env.add_object_call([:object, :string, [[:id, :x]]], :capitalize, PString.capitalize)
      env.add_object_call([:object, :string, [[:id, :x]]], :center, PString.center)
      env.add_object_call([:object, :string, [[:id, :x]]], :downcase, PString.downcase)
      env.add_object_call([:object, :string, [[:id, :x]]], :is_empty, PString.is_empty)
      env.add_object_call([:object, :string, [[:id, :x]]], :hex, PString.hex)
      env.add_object_call([:object, :string, [[:id, :x]]], :index, PString.index)
      env.add_object_call([:object, :string, [[:id, :x]]], :insert, PString.insert)
      env.add_object_call([:object, :string, [[:id, :x]]], :length, PString.length)
      env.add_object_call([:object, :string, [[:id, :x]]], :oct, PString.oct)
      env.add_object_call([:object, :string, [[:id, :x]]], :reverse, PString.reverse)
      env.add_object_call([:object, :string, [[:id, :x]]], :to_integer, PString.to_integer)
      env.add_object_call([:object, :string, [[:id, :x]]], :to_decimal, PString.to_decimal)
      env.add_object_call([:object, :string, [[:id, :x]]], :upcase, PString.upcase)
    end
    
    def PString.append
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0] + values[1].params[0]])
      end
      lamb.form = [[:object, :string, [[:id, :x]]], [:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.equal
      lamb = Proc.new do |values|
        if values[0].params[0] == values[1].params[0]
          PObject.new(:boolean, [true])
        else
          PObject.new(:boolean, [false])
        end
      end
      lamb.form = [[:object, :string, [[:id, :x]]], [:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.at
      lamb = Proc.new do |values|
        PObject.new(:char, [values[0].params[0][values[1].params[0],1]])
      end
      lamb.form = [[:object, :string, [[:id, :x]]], [:object, :integer, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.capitalize
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].capitalize])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.center
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].center(values[1].params[0])])
      end
      lamb.form = [[:object, :string, [[:id, :x]]], [:object, :integer, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.downcase
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].downcase])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.is_empty
      lamb = Proc.new do |values|
        PObject.new(:boolean, [values[0].params[0].empty?])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.hex
      lamb = Proc.new do |values|
        PObject.new(:integer, [values[0].params[0].hex])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.index
      lamb = Proc.new do |values|
        i = values[0].params[0].index(values[1].params[0])
        if i
          PObject.new(:integer, [i])
        else
          PObject.new(:nil, [])
        end
      end
      lamb.form = [[:object, :string, [[:id, :x]]], [:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.insert
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].insert(values[1].params[0], values[2].params[0])])
      end
      lamb.form = [[:object, :string, [[:id, :x]]], [:object, :integer, [[:id, :x]]], [:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.length
      lamb = Proc.new do |values|
        PObject.new(:integer, [values[0].params[0].length])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.oct
      lamb = Proc.new do |values|
        PObject.new(:integer, [values[0].params[0].oct])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.reverse
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].reverse])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.to_integer
      lamb = Proc.new do |values|
        PObject.new(:integer, [values[0].params[0].to_i])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.to_decimal
      lamb = Proc.new do |values|
        PObject.new(:decimal, [values[0].params[0].to_f])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
    def PString.upcase
      lamb = Proc.new do |values|
        PObject.new(:string, [values[0].params[0].upcase])
      end
      lamb.form = [[:object, :string, [[:id, :x]]]]
      [lamb]
    end
    
  end
end
