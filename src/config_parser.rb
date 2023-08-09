class ConfigParser

  def inititalize
    @port = 8082
    @route = []
  end

  def port(p)
    @port = p
  end

  def route(&block)
    yield
  end
  
end
