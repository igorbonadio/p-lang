class Proc
  def form=(form)
    @form = form
  end
  
  def compare_form(form, obj)
    if(form)
      unless obj[1] == form[1]
        return false
      else
        if form[0] == :literal
          unless form == obj
            return false
          end
        else
          form[2].each_with_index do |p, i|
            unless p[0] == :id
              unless p == obj[2][i]
                if p[0] == :object
                  return compare_form(p, obj[2][i])
                else
                  return false
                end
              end
            end
          end
        end
      end
    end
    return true
  end

  def call?(params)
    params.each_with_index do |param, i|
      unless compare_form(@form[i], param.form)
        return false
      end
    end
    return true
  end
end