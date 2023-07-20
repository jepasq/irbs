# Handles command line arguments for the engine

class Argument
  @opts= nil # The list of options

  def initialize
    @opts= Array.new
  end
  
  def add(option)
    raise ArgumentError unless option.is_a?(ArgumentOption)

    @opts << "aze"
  end

  def consume(argv)
    raise ArgumentError unless option.is_a?(Array)
    
  end
  
end

class ArgumentOption

end
