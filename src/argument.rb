require_relative 'argument_option'

# Handles command line arguments for the engine

# The command line argument handling class
#
# Based on a ArgumentOption array, you can add instances of this class only.
class Argument
  attr_reader :opts # The list of options

  # The argument default constructor
  def initialize
    @opts= Array.new
  end

  # Add an ArgumentOption to the options array
  #
  # @option The argument of the ArgumentOption type.
  #
  # @raise May raise an ArgumentError if a bad argument type is provided.
  #
  def add(option)
    raise ArgumentError unless option.is_a?(ArgumentOption)

    @opts << option
  end

  # Raise an error if unknown argument is passed
  def raise_if_unknown_arg(argv)
    ttt= argv.dup
    ## but before, remove all non-arguments ones
    ttt = ttt.select{|e| e.start_with? '-'}
    # Remove all to-be-handled arguments from a copied array
    ttt.delete_if do |elem|
      @opts.any? do |e2|
        e2.aliases.include?(elem)
      end
    end
    
    msg = ttt.join(',')
    raise ArgumentError.new "#{msg} argument(s) unknown" unless ttt.empty?
  end

  # Consume the given argv array and fire argument action if needed
  #
  # @param argv An array of string containing user's argument
  def consume(argv)
    raise ArgumentError.new("argv must be an array") unless argv.is_a?(Array)
    raise_if_unknown_arg(argv)

    @opts.each do |o|
      o.fire_if argv
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

  # Add the help/usage argument
  def add_usage
    help = ArgumentOption.new('--help', 'Show usage text and exit') do
      puts "irbs v#{VERSION}-#{REVISION} usage text :\n"
      puts "An Inspection/Representation Based web Server."
      
      puts "\nOptions :"

      # First, compute first column max width
      widths = Array.new
      @opts.each do |a|
        widths << a.first_column.length
      end
      w = widths.max

      # Special case, the help option
      print "  " + "--help, -h, -?".ljust(w+1, ' ')
      puts "Print this usage text and exit with 0 status."
      
      @opts.each do |a|
        puts "  #{a.full_text(w)}"
      end
      # Prevent the unit tests from exiting from argument.rspec 
      exit(0) unless ENV['APP_ENV']=='test'
    end
    help.add_alias "-h"
    help.add_alias "-?"
    add(help)
  end
  
end

