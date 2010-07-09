module PLang
  class PError    
    def PError.raise_error(error_name, error_message)
      puts error_name.to_s + ": " + error_message
      raise "PError.raise_error"
    end
  end
end