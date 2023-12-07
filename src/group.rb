


# A group is a named container often used as an HTML section, header etc...
class Group
  attr_accessor :name

  attr_reader :items
  
  
  def initialize(name)
    @name = name
    @items = Array.new
  end

  def add(str)
    raise ArgumentError unless str.is_a?(String)
    
    @items << str
  end

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
