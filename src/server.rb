
# The main server
class Server
  attr_reader :interactive, :endpoint, :port

  def initialize
    @interactive = true
    @endpoint    = '/'
    @port        = 8082
  end
  
end
