module PLang
  class PError    
    def PError.raise_error(error_name, error_message)
      puts error_name.to_s + ": " + error_message
      exit
    end
  end
end