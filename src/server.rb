require_relative 'config_parser.rb'
require_relative 'favicon'

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
    puts "Opening project configuration from '#{script}'"
    # The content of the HTML page
    page = ""
    
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

    # favicon handling
    if parser.routes['/favicon.ico'] then
      fav = Favicon.new(File.join(directory, parser.routes['/favicon.ico']))
      page = page + fav.to_s
    end
    
    # Open server
    p = parser.port
    socket = TCPServer.new(p)
    puts "Listening on port #{p}..."
    loop do                                                  
      client = socket.accept                                 
      first_line = client.gets                               
      verb, path, _ = first_line.split                       

      # clp: [address_family, port, hostname, numeric_address]
      clp = client.peeraddr
      cl = "#{clp[0]}=> #{clp[2]}:#{clp[1]}"

      if verb == 'GET'
        if path == '/'
          slur = :root
        elsif path = '/favicon.ico'
          break
        else
          slur = path
        end
        puts "#{cl} GET #{path}"
        text="HTML content goes here!!"
        begin
          classn =  parser.routes[slur].capitalize
        rescue
          puts "WARN: can't get classname from slur '#{slur}'"
        end
        classfile = File.join(directory, classn + '.rb')
        require classfile
        # see https://stackoverflow.com/a/5924555
        instance = Kernel.const_get(classn).new
        puts "Instancing '#{classn}' from '#{classfile}'"
        client.puts(success(page + instance.to_s))
      end                                                    
      
      client.close                                           
    end                                                      
    socket.close  
  end

  # A simple HTTP 200 response text shortcut
  def success(text)
    "HTTP/1.1 200\r\n\r\n#{text}"
  end
  
end
