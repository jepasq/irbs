
# A class used to parse the content returned by a .to_s() function
#
# The representation of an instance must be parsed for :
# - other classes : <tt>=Classname</tt>
#
# Maybe:
# - class with ctor parameter <tt>=ClassName("az",20)</tt>
# - class with attribute set <tt>=ClassName{attr1=12}</tt>
#
class Parser
  attr_accessor :directory
  
  # The regex that should match the parsable name of a class (i.e. =ClassName)
  REGEX_CLASS = /=([A-Z][A-Za-z0-9]*)\b/

  # The constructor that takes a directory parameter
  #
  # @param dir The directory where we will search for classes implementation.
  #            It can be nil and will not be checked for existance.
  def initialize(dir = nil)
    @directory = dir
  end

  # Instanciates the class, get its representation and replace string
  #
  # @param c The class name as found in the representation.
  def create_instance(c)
    #   Trying ot get rid of 'no-implicit-conversion-of-nil-into-string'
    #   using both string interpolation and .to_s
    classfile = File.join(@directory.to_s, class_to_filename(c))
    begin
      require_relative classfile
    rescue LoadError
      # Prints the dir to be sure
      puts "Failed to load '#{__dir__}#{classfile}' For object `#{c}'"
      puts "  (cannot load such file)"
    rescue Exception => e
      puts $!
      raise e
    end
    puts "Trying to get constant '#{c}'"
    return Kernel.const_get(c).new
  end
  
  # classnames from the given string and return them in an array
  def extract_classes(txt)
    txt.scan(REGEX_CLASS).flatten
  end

  # Extract then replace the text by the classes representation
  def handle_classes(txt)
    ret = txt
    if @directory
      extract_classes(txt).each do |c|
        instance = create_instance(c)
        ret.gsub!( '=' + c, instance.to_s)
      end
    end
    ret
  end
  
  # Parse the given text and return it with all code handled
  #
  # @param txt The text to be parser. Generally from a class instance
  #        representation.
  #
  # @raise [ArgumentError] If the given txt argument is not a string.
  #
  # @return The parsed text.
  def parse(txt)
    unless txt.is_a?(String)
      raise ArgumentError.new("Argument should be a string")
    end
    
    return handle_classes(txt)
  end

  # Return the first HTML opening tag from a string or nil if not found
  #
  # @param str [String] The string we'll search tags in.
  #
  # @return [String] The first opening tag in the given string.
  #
  def get_first_opening_tag(str)
    tag = str.match(/<[a-zA-Z](.*?[^?])?>/)

    if tag.nil?
      return tag
    else
      return tag[0]
    end
  end

  # return a string where we add classes to, for example div
  #
  # @param str [string] The string to-be-parsed with #extract_classes()
  #            #and parse().
  #
  # @return [String] The parsed string once classes extracted.
  #
  def add_cssclass(str)
    extract_classes(str).each do |c|
      instance = create_instance(c)
      
      p instance.cssclass
    end
    return parse(str)
  end

  # Return the filename based on a class name foudn in the representation
  #
  # If we found '=ClassName', this function will return the file where we
  # can find its definition.
  #
  # @param c [String] The base camel-cased class name.
  def class_to_filename(c)
    # Thanks to https://stackoverflow.com/a/1509939
    d=c.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_")
    "#{d.downcase}.rb"
  end
end
