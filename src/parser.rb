
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
