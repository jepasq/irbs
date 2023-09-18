# Represent a single argument option with a yield block, a help text
# and possibly multiples aliases
class ArgumentOption
  attr_reader :aliases
  
  def initialize(text, help, &block)
    @help = help
    @action = block
    @aliases = [text]
  end  

  # Fire the instance's action
  def fire
    @action.call
  end

  def add_alias(text)
    @aliases << text
  end

  # Fire the action if the arg value is included in @aliases array
  #
  # \return true if fired, false otherwise
  def fire_if(arg)
    if arg.is_a? Array
      fire_if_array arg
    end

    if @aliases.include? arg
      self.fire
      return true
    else
      return false
    end
  end

  def fire_if_array(arg)
    arg.each do |a|
      fire_if a
    end
  end
  
  # Return all aliases and help text in a single string
  #
  # It is used to be print it in terminal during usage message.
  #
  # @param column_width First column width to be padded with.
  def full_text(column_width = 2)
    ret  = aliases.join(', ').ljust(column_width, ' ')
    ret += ' ' + @help
    ret
  end

  # Handle text representation here
  def to_s
    aliases[0]
  end
end
