class Favicon
  def initialize(path)
    @path = path
    puts "WARN: Can't find favicon '#{path}'" unless File.exist? path
  end

  def mime_type
    ext = File.extname(@path).downcase
    MIME::Types.type_for(ext)
  end
  
  def to_s
    "<link rel='icon' type='#{mime_type[0].to_s}' href='#{@path}'>"
  end
end
