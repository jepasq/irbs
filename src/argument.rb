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
    # Remove all to-be-handled arguments from a copied array
    ttt= @opts
    ## but before, remove all non-arguments ones
    argv2 = argv.select{|e| e.start_with? '-'}
    ttt.delete_if do |elem|
      elem.aliases.include? argv2[0]
    end
    
    msg = ttt.join(',')
#    raise "#{msg} argument(s) unknown" unless ttt.empty?
    
    @opts.each do |o|
      # Remove the test one so we can know wich one wasn't handled
      break if o.fire_if argv
    end
  end
  
end

# Represent a single argument option with a yield block, a help text
# and possibly multiples aliases
class ArgumentOption
  attr_reader :aliases
  
  def initialize(text, help, &block)
    @help = help
    @action = block
    @aliases = [text]
  end  

  def fire
    @action.call
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

  def full_text
    ret  = sprintf "%10s", aliases.join(', ')
    ret += @help
    ret
  end

  # Handle text representation here
  def to_s
    aliases[0]
  end
end
