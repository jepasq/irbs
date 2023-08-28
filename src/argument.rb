require_relative 'argument_option'

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

  # Raise an error if unknown argument is passed
  def raise_if_unknown_arg(argv)
    # Remove all to-be-handled arguments from a copied array
    ttt= @opts.dup

    ## but before, remove all non-arguments ones
    argv2 = argv.select{|e| e.start_with? '-'}
    ttt.delete_if do |elem|
      argv2.any? do |e2|
        elem.aliases.include?( e2)
      end
    end

    p argv2
    p @opts.map(&:aliases)
    p argv2 - @opts
    
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
      # Remove the test one so we can know wich one wasn't handled
      
      puts "#2 Running fire_if on #{o.aliases} using #{argv}"
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

