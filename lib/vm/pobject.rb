module PLang
  class PObject
    attr_accessor :type
    attr_accessor :params
    
    def initialize(type, params)
      @type = type
      @params = params
    end
    
  end
end