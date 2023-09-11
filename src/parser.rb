
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
  # The regex that should match the parsable name of a class (i.e. =ClassName)
  REGEX_CLASS = /=([A-Z][A-Za-z0-9]*)\b/

  # Extract classnames from the given string and return than in an array
  def extract_classes(txt)
    txt.scan(REGEX_CLASS).flatten
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
    
    return txt
  end               
end
