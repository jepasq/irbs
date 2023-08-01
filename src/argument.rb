# Handles command line arguments for the engine

# The command line argument handling class
#
# Based on a ArgumentOption array, you can add instances of this class only.
class Argument
  attr_reader :opts # The list of options

  def initialize
    @opts= Array.new
  end
  
  def add(option)
    raise ArgumentError unless option.is_a?(ArgumentOption)

    @opts << option
  end

  def consume(argv)
    @opts.each do |o|
      # Remove the test one so we can know wich one wasn't handled
      @opts.delete o
      break if o.fire_if argv
    end

    raise ArgumentError unless @opts.empty?
  end
  
end

# Represent a single argument option with a yield block, a help text
# and possibly multiples aliases
class ArgumentOption
  def initialize(text, help)
    @help = help
    @action = yield
    @aliases = [text]
  end  

  def fire
    @action
  end

  def add_alias(text)
    @aliases << text
  end

  def fire_if(arg)
    if @aliases.include? arg
      @action
      return true
    else
      return false
    end
  end

  # Handle text representation here
  def to_s
    ret  = sprintf "%10s", aliases.join(', ')
    ret += @help
    ret
  end
end
