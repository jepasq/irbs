# A project configuration DSL
#
# This parser is used to define keyword that can be used in a DSL to configure
# irgs server.
class ConfigParser
  # The port the server will listen to new connection on
  attr_accessor :port
  
  # A hash of key/value serving as routes
  #
  # This will be used as :
  #      slur   -> classname association
  #   :profile: => class defined in Profile.rb 
  attr_accessor :routes

  # The default calues for server configuration
  def initialize
    @port = 8082
    @routes = Hash.new
    @routes['root'] = 'application'
  end

  # Change the server's listening port
  #
  # @param p The ne port as integer
  def port=(p)
    @port = p
  end

  # Change the favicon
  #
  # @param p The new favicon filename
  def favicon=(p)
    @routes['/favicon.ico'] = p
  end

  # A route block
  #
  # @param block A yield block
  def route(&block)
    yield
  end

  # Add a route association to the route hash
  #
  # Designed to be used in route() block.
  #
  # @param key   The slur hash key.
  # @param value The hash classname.
  def endpoint(key, value)
    @routes[key] = value
  end
  
end
