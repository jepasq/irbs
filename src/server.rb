
# The main server
class Server
  attr_reader :interactive, :endpoint, :port

  def initialize
    @interactive = true
    @endpoint    = '/'
    @port        = 8082
  end

  # Return the actual endpoint to a ruby Classname
  def endpoint_to_classname
    if @endpoint == '/'
      "Home"
    else
      @endpoint.capitalize
    end
  end
    
end
