require_relative 'config_parser.rb'

require 'socket'

# The main server
class Server
  attr_reader :interactive, :endpoint

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
    begin
      parser.instance_eval(content)
    rescue => e
      puts "Failed to parse #{script} : #{e}"
      exit(1)
    end
    parser

    # Open server
    p = parser.port
    socket = TCPServer.new(p)
    puts "Listening on port #{p}"
    loop do                                                  
      client = socket.accept                                 
      first_line = client.gets                               
      verb, path, _ = first_line.split                       
      
      if verb == 'GET'                                       
        puts "Client connected to #{path}"
        response = "HTTP/1.1 200\r\n\r\nHTML content goes here!!"
        client.puts(response)                              
      end                                                    
      
      client.close                                           
    end                                                      
    
    socket.close  

    
  end
  
end
