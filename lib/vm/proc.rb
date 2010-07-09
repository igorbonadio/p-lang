class Proc
  attr_accessor :form
  
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
          if obj[0] == :literal
            unless form[2].length == 1
              return false
            else
              unless form[2][0][0] == :id
                return false
              end
            end
          else
            if form[2].length == obj[2].length
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
            else
              return false
            end
          end
        end
      end
    end
    return true
  end

  def call?(params)
    if @form.length == params.length
      params.each_with_index do |param, i|
        unless param.class == Array
          unless compare_form(@form[i], param.form)
            return false
          end
        else
          if @form[i]
            return false
          end
        end
      end
      return true
    else
      return false
    end
  end
  
  def to_s
    "#lambda:#{self.object_id}"
  end
end
