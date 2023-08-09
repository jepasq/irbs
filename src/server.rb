require_relative 'config_parser.rb'

# The main server
class Server
  attr_reader :interactive, :endpoint, :port

  def initialize
    @interactive = true
    @endpoint    = '/'
  end

  # Return the actual endpoint to a ruby Classname
  def endpoint_to_classname
    if @endpoint == '/'
      "Home"
    else
      @endpoint.capitalize
    end
  end

  # Run from the given directory
  def run(directory)
    script = File.join(directory, 'config.rb')
    puts "Opening project configuration from '#{script}'..."

    # From https://www.paweldabrowski.com/articles/building-dsl-with-ruby
    # (Search for 'Parsing source' h3 header
    content = File.read(script)
    parser = ConfigParser.new
    parser.instance_eval(content)
    parser
  end
  
end
