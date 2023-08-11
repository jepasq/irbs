class Favicon
  def initialize(path)
    @path = path
    puts "WARN: Can't find favicon '#{path}'" unless File.exist? path
  end

  def mime_type
    ext = File.extname(@path).downcase
    p ext
  end
  
  def to_s
    "<link rel='icon' type='#{mime_type}' href='#{@path}'>"
  end
end
