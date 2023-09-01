
# A class used to parse the content returned by a .to_s() function
#
# The representation of an instance must be parsed for :
# - other classes : =Classname
#
# Maybe:
# - class with ctor parameter =ClassName("az",20)
# - class with attribute set =ClassName{attr1=12}
#
class Parser
  def parse(txt)
    return txt
  end               
end
