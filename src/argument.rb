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
    raise ArgumentError.new("argv must be an array") unless argv.is_a?(Array)

    # Remove all to-be-handled arguments from a copied array
    ttt= @opts
    ## but before, remove all non-arguments ones
    argv2 = argv.select{|e| e.start_with? '-'}
    ttt.delete_if do |elem|
      argv2.each do |e2|
        elem.aliases.include? e2
      end
    end
    
    msg = ttt.join(',')
    raise "#{msg} argument(s) unknown" unless ttt.empty?

    @opts.each do |o|
      # Remove the test one so we can know wich one wasn't handled
      break if o.fire_if argv
    end
  end

  # Return a copy of the array passed as argument minus all
  # dash-starting options
  def only_dirs(args)
    ttt = args
    ttt.delete_if do |elem|
      elem.start_with? '-'
    end
    ttt
  end

  def add_usage
    help = ArgumentOption.new('--help', 'Show usage text and exit') do
      puts "irbs v#{VERSION}-#{REVISION} usage text :\n"
      puts "An Inspection/Representation Based web Server."
      
      puts "\nOptions :"
      puts "  --help, -h, -?   Print this usage text and exit with 0 status."
      @opts.each do a
        puts "  #{a.full_text}"
      end
      exit(0)
    end
    help.add_alias "-h"
    help.add_alias "-?"
    add(help)
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

  # Fire the action if the arg value is included in @aliases array
  #
  # \return treu if fired, false otherwise
  def fire_if(arg)
    if @aliases.include? arg
      self.fire
      return true
    else
      return false
    end
  end

  # Return all aliases and help text in a single string
  #
  # It is used to be print ed in terminal during usage message.
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
