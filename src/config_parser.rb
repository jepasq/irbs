require_relative 'group'

# A project configuration DSL
#
# This parser is used to define keyword that can be used in a DSL to configure
# irbs server.
#
# This class also contain the header group that can be used to modify
#
# We try to avoid automatically-generated getter and setter here to replace
# them with get_*** because the setter is better without '=' sign.
class ConfigParser
  
  # A hash of key/value serving as routes
  #
  # This will be used as :
  #      slur   -> classname association
  #   :profile: => class defined in Profile.rb 
  attr_accessor :routes

  # A group used to add favicon link and other header section content
  attr_accessor :header

  
  # The default calues for server configuration
  def initialize
    @port = 8082
    @routes = Hash.new
    @routes['root'] = 'application'
    @header = Group.new "Header"
  end

  # Change the favicon
  #
  # @param p The new favicon filename
  def favicon (p)
    @routes['/favicon.ico'] = p
    @header.add('<link rel="icon" type="image/x-icon" href="' + p + '">')
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

  # Return the HTML title markup if not nil
  #
  # @return The title markup and its content from the title instance variable.
  def title_content
    "<title>#{@title}</title>" if @title
  end

  def port(p)
    @port = p
  end

  # Set the document title to t
  #
  # It's value is maily used in title_content()
  #
  # @param t The new title value
  def title(t)
    @title = t
  end

  # We can't use a simple attr_reader here as its name conflicts with setter
  # and we want setter to be called without '=' (equal) sign
  def get_title
    @title
  end

  def get_port
    @port
  end

  
  
end
