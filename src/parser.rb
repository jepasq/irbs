
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
  
  # Extract classnames from the given string and return than in an array
  def extract_classes(txt)
    txt.scan(REGEX_CLASS).flatten
  end

  # Extract then replace the text by the classes representation
  def handle_classes(txt)
    ret = txt
    extract_classes(txt).each do |c|
      # Instanciates the class, get its representation and replace string
      classfile = File.join(@directory, c.downcase + '.rb')
      require_relative classfile
      instance = Kernel.const_get(c).new
      ret.gsub!( '=' + c, instance.to_s)
    end
    ret
  end
  
  # Parse the given text and return it with all code handled
  #
  # @param txt The text to be parser. Generally from a class instance
  #        representation.
  #
  # @return The parsed text.
  def parse(txt)
    unless txt.is_a?(String)
      raise ArgumentError.new("Argument should be a string")
    end
    
    return handle_classes(txt)
  end

  # Return the first HTML opening tag from a string or nil if not found
  def get_first_opening_tag(str)
    tag = str.match(/<[a-zA-Z](.*?[^?])?>/)

    if tag.nil?
      return tag
    else
      return tag[0]
    end
  end
end
