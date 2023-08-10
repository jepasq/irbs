class ConfigParser
  attr_accessor :port, :routes
  
  def initialize
    @port = 8082
    @routes = Hash.new
  end

  def port=(p)
    @port = p
  end

  def favicon=(p)
    @routes['/favicon.ico'] = p
  end
  
  def route(&block)
    yield
  end

  def endpoint(a, b)
    @routes[a] = b
  end
  
end
