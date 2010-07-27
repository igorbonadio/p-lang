module PLang
  module VM
    class PLambda < Proc
            
      def call?(params)
        _call?(params, @form||[])
      end
      
      def _call?(params, form)
        if form.length == params.length
          form.each_with_index do |f, i|
            if f
              case f.type
                when :integer, :decimal, :char, :string
                  if f.type == params[i].id
                    unless f.value == params[i].params[0]
                      return false
                    end
                  end
                when :object
                  unless f.id.value == params[i].id
                    return false
                  else
                    unless _call?(params[i].params, f.params)
                      return false
                    end
                  end
              end
            end
          end
          return true
        else
          return false
        end
      end
      
      def form
        @form ||= []
      end
    end
  end
end