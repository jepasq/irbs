# A favicon (favorite icon) if a graphic files associated by a browser
# with a particular website or wabpage
class Favicon
  def initialize(path)
    @path = path
    puts "WARN: Can't find favicon '#{path}'" unless File.exist? path
  end

  def mime_type
    ext = File.extname(@path).downcase
    MIME::Types.type_for(ext)
  end

  # Return the string representation of this favicon
  #
  # @return Basically a very simple <link> markup
  #
  def to_s
    "<link rel='icon' type='#{mime_type[0].to_s}' href='#{@path}'>"
  end
end
