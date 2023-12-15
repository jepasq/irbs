require_relative 'config_parser.rb'
require_relative 'favicon'
require_relative 'parser'

require 'socket'

# The main server
class Server
  # A boolean setting if server must listen to client connection or simply
  # print generated pages to stdout.
  attr_accessor :interactive

  # The URL the client try to connect to.
  attr_accessor :endpoint

  # Return a new interactive Server instance
  #
  # The #endpoint attribute is set to '/'.
  def initialize
    @interactive = true
    @endpoint    = '/'
    @directory = "~"
  end

  # Puts if interactive
  def pii(msg)
    if @interactive
      puts msg
    else
#      STDERR.puts msg
    end
  end
  
  # Return the actual endpoint to a ruby Classname
  def endpoint_to_classname
    if @endpoint == '/'
      "Home"
    else
      @endpoint.capitalize
    end
  end

  # Returns representation of a page indentified by the given slur
  #
  # Here, the endpoint/slur will be use to get the class name from the router.
  # Il will then be used to create the needed class instance.
  #
  # @param slur The part of URL we call endpoitn or slur.
  #
  # @return the instance content as string
  #
  def page_content(slur)
    classn=""
    begin
      classn =  parser.routes[slur].capitalize
    rescue
      pii "WARN: can't get classname from slur '#{slur}'"
      classn = 'Application'
    end

    classfile = File.join(@directory, classn + '.rb')
    require classfile
    # see https://stackoverflow.com/a/5924555
    instance = Kernel.const_get(classn).new
    pii "Instancing '#{classn}' from '#{classfile}'"

    # Parse and print
    pa = Parser.new @directory
    
    pa.parse instance.to_s
  end

  # Return a string representation of the @interactive field
  #
  # @return [String] a human readable representation.
  def interactive_to_s
    ret = ""
    ret += "non " unless @interactive
    ret += "interactive"
    ret 
  end
  
  # Run from the given directory
  def run(directory)
    @directory = directory

    pii "Entering #{interactive_to_s} mode"
    
    script = File.join(directory, 'config.rb')
    pii "Opening project configuration from '#{script}'"

    # The content of the HTML page
    page = ""
    
    # From https://www.paweldabrowski.com/articles/building-dsl-with-ruby
    # (Search for 'Parsing source' h3 header
    parser = ConfigParser.new
    begin
      content = File.read(script)
      parser.instance_eval(content)
    rescue => e
      puts "Failed to parse #{script} : #{e}"
      exit(1)
    end

    # favicon handling
    if parser.routes['/favicon.ico'] then
      fav = Favicon.new(File.join(directory, parser.routes['/favicon.ico']))
      pii "Adding favicon code #{fav}"
      page = page + fav.to_s
    end

    if not @interactive
      puts parser.title_content
      puts parser.header.to_str
      puts page_content(:root)
      exit(0) 
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
        elsif path == '/favicon.ico'
          break
        else
          slur = path
        end
        puts "#{cl} GET #{path}"
        text = parser.title_content
        text+= parser.header.to_str
        text+= page + page_content(slur)
        client.puts(success(text))
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
