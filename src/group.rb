


# A group is a named container often used as an HTML section, header etc...
#
class Group
  # The group name, printed between < and > chars
  attr_accessor :name

  # [Array] items An items array. If empty, section is not printed
  attr_reader :items
  
  # Named constructor
  def initialize(name)
    @name = name
    @items = Array.new
  end

  # Add an item to the items array
  #
  # @param str {string} The item to be added.
  #
  # @raise [ArgumentError] If the provided argument is not a string.
  def add(str)
    raise ArgumentError unless str.is_a?(String)
    
    @items << str
  end

  # Return a string representation of this group, including all its children
  #
  # @return [string] The object representation.
  def to_str
    if @items.empty?
      return ""
    else
      a="<"+@name+">"
      a+=@items.join
      a+="</"+@name+">"
      return a
    end
  end
  
end
