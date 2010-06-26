class Proc
  def form=(form)
    @form = form
  end

  def call?(params)
    ok = true
    params.each_with_index do |param, i|
      if(@form[i])
        unless(@form[i] == param)
          ok = false
          break
        end
      end
    end
    ok
  end
end